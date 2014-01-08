//Auto-resize function

function setMinHeight(divName){
	if (divName === "home"){
		$('#'+divName) .css({'min-height': (($(window).height())-50) + 'px'});
	}else{
		$('#'+divName) .css({'min-height': (($(window).height())) + 'px'});
	}
}

$(document).ready(function($) { 
	setMinHeight("home");
	setMinHeight("about");
	setMinHeight("members");
	setMinHeight("projects");
	var init = ($('#nav')).offset().top;
	var docked;
	var nav = ($('#nav'));
	function dockOrNot(){
		// alert("top="+$(window).scrollTop() );
		if(!docked && (nav.offset().top-($(window).scrollTop() || $('html, body').scrollTop()) <0)){
			$('#nav').css({
				position: 'fixed',
				top:0
			});
			docked=true;
		}else if(docked && $(window).scrollTop() <= init){
			$('#nav').css({
				position: 'absolute',
				top:init+"px"
			});
			docked=false;
		}
	}
	$(window).scroll(function() {
		dockOrNot();
	});
	$(window).resize(function(){
		setMinHeight("home");
		setMinHeight("about");
		setMinHeight("members");
		setMinHeight("projects");
		init = ($('.nav')).offset().top;
		dockOrNot();
	});

	$('.subscribe').click(function (){
		$('.subscribeBox').slideDown();
	});
  	$('.subscribeBox').submit(function(e) {
    	$('.subscribeBox [type="submit"]').attr('disabled', 'disabled');

    	$('.error-subscribe').hide(); //clears any previous errors
    	var url = 'http://cgi.stanford.edu/group/premed-apamsa/cgi-bin/email_signup.php';
    	var email = $('input#email').val();
    	var email_compare = /^([A-Za-z0-9_.-]+)@([da-z.-]+).([a-z.]{2,6})$/;
    	var stanford_email_compare = /^([A-Za-z0-9_.-]+)@([da-z.-])stanford.edu$/;
    	var error = false;
    	if (!email_compare.test(email)){
    		$('.error-subscribe').fadeIn();
    		error=true;
    	}
    	if(!error && !stanford_email_compare.test(email)){
    		$('.stanford-error-subscribe').fadeIn();
    	}
    	alert("email=" + email);
	    $.ajax(url, {
	      dataType: "jsonp",
	      data: {
	        email: $('.subscribeBox [name="email"]').val()
	      }
	    }).success(function(e) {
	      $('.subscribeBox').slideUp(function() {
	        $('.subscribeBox')
	          .empty()
	          .html('<h2 style="color: green;">Success! Click the link in your email to confirm.</h2>')
	          .slideDown();
	      });

	    }).error(function(e) {
	      alert('There was an error and you were NOT subscribed to the mailing list. If you\'re feeling kind, send an email to the Stanford Premed APAMSA officers list (pre-med_apamsa_board@lists.stanford.edu) or Sherman (skleung@stanford.edu) and let us know so we can fix it.');

	      $('.subscribeBox [type="submit"]')
	        .removeAttr('disabled');
	    });

	    e.preventDefault();
	    e.stopPropagation();
	    return false;
	  });
});



$(window).resize(function() {
	$('.welcome').css({
		left: ($(window).outerWidth() - $('.welcome').outerWidth()) / 2 + 'px',
		top: ($(window).outerHeight() - $('.welcome').outerHeight()) / 2 + 'px'
	});
});

$(document).ready(function($) { 

});

//feature-box javascript
$(document).ready(function($) { 
	var added = ["spencer", "jasonku","jasonkh","jessica","sherman", "cheylene", "stephen","catherine"];
	var names = ["stephen", "spencer", "steven", "jasonkh","jasonku","sherman","phuong", "jessica", "cheylene", "catherine"];
	var fullNames = ["Stephen Ahn", "Spencer Chang", "Steven Chen", "Jason Khoo", "Jason Kung", "Sherman Leung", "Phuong Ngyuen", "Jessica Shen", "Cheylene Tanimoto", "Catherine Zaw"];
	var titles = ["Founding Member", "President", "Founding Member", "Founding Member", "Founding Member", "Secretary","Treasurer", "Founding Member", "Founding Member","Vice-President"];
	var jessicaText = "Hello! I'm majoring in Biology, with my interest mostly on the organismal scale of things. In my free time, I enjoy playing gigs with my viola and doodling on piano and paper. With the opportunities afforded this organization by its infancy, I'm looking forward to finding and hopefully filling gaps within the community."
	var jasonkuText = "Hello! My name is Jason and I am a 3rd year biology major with a focus on molecular/cellular/developmental biology. In joining APAMSA, I hope to learn more about health care and the issues that affect the API community. Like the other founding members, I am excited to see where this group will go and see how it impacts the university. In my spare time, you can find me planning events, learning graphic design, or enjoying a freshly brewed coffee at a cafe."
	var spencerText = "I’m a Biology major from Portland, Oregon. Starting this organization, I had two things in mind: 1) to foster a community amongst API premeds and those interested in API health issues, and 2) to address and educate others of the many health disparities affecting the API population. I am very interested in the changes to come with healthcare in our country and how greater accessibility to healthcare might or might not change the current outlook on health disparities. Outside of Stanford Pre-Med APAMSA, you can find me doing research in the Department of Microbiology and Immunology on host-pathogen interactions involving Salmonella infections and their persistence in a host, volunteering at Arbor Free Clinic, teaching health education curriculum to underprivileged students in the area, drinking coffee, watching prank videos on youtube, rooting for the Portland Trailblazers, among other things. I am really excited for Stanford Pre-Med APAMSA to become a strong, close-knit community on campus, and to make a positive impact on the Stanford community and beyond."
	var shermanText = "I'm a computer science major interested in building mobile applications to make healthcare more accessible and medicine better understood. Outside of school, I can be found designing websites, apps, or producing music. I'm excited for the start of this group, and to share my experiences as an unconventional premed."
	var jasonKhooText = "Hi! I'm a Human Biology major interested in how we can best optimize our health systems to supply the ever increasing demand for affordable health care. I'm particularly excited about how collaboration between health workers, policy writers, and biotech innovators can revolutionize the industry as we know it. Outside of classes you can find me watching a bajillion movies/tv shows, playing hockey, at the squash courts, or obsessing over food. I'm super excited to be working with the awesome team of floating heads on the right to help others on their premed journey."
	var cheyleneText = "I'm majoring in human biology with a focus on bio-medical science. I am interested in providing healthcare to those in need. I am in a polynesian dance group called Kaorihiva and I love to cook and bake. I'm excited to see where this group will go, providing valuable information to premed students and also increasing awareness of Asian American health disparities. "
	var catherineText = "I'm a biology and linguistics major interested in alleviating health disparities in less fortunate communities. Future goals include finishing a novel, walking the Great Wall of China, owning a food truck and eventually become a doctor. I'm a writer by nature, philanthropist in mind, scientist at heart, and food lover for life. Seeing APAMSA's potential inspires me to make sure that our vision is carried through and I'm so fortunate to be working with a team full of bright and talented people."
	var stephenText = "I'm a Biology major focused on Molecular and Cell Biology. Among other things, I'm primarily interested in oncology and the concept of understanding cancer so we may one day conquer it. Outside of school, you can catch me blasting music, jamming on my cello, or going on a run. Creating our impact through APAMSA excites me to no end, and I'm thrilled to be able to share my knowledge and experiences along the journey ahead."
	var text = [stephenText, spencerText, "steven says...",jasonKhooText, jasonkuText,shermanText,"phuong says...",jessicaText,cheyleneText,catherineText]
	function swap(i){
		swapHelper(names,i);
		swapHelper(fullNames,i);
		swapHelper(titles,i);
		swapHelper(text,i);
	}
	function swapHelper(arr,i){
		var first = arr[0];
		arr[0] = arr[i];
		arr[i] = first;
	}
	function list(id){
		$("#"+id).hide();
		if (added.indexOf(names[0]) > -1){
			$("#"+id).css({
				'background-image': "url('images/members/circle-"+names[0]+".png')",
				'background-size': '100% 100%'
			});
		}else{
			$("#"+id).css({
				'background-image': "url('images/apamsa a.png')",
				'background-size': '100% 100%'
			});
		}
		$("#"+id).fadeIn(1500);
	}
	function feature(){
		$(".feature-box").hide();
		$(".name").html(fullNames[0]);
		$(".title").html(titles[0]);
		$(".description").html(text[0]);
		// $(".img").html("<img src = "images/svg/person.svg" alt = "person">");
		// "<img src = 'images/svg/person.svg' alt = 'person'>");
		$(".featured-image").css({
			'background-image': 'url("images/members/'+names[0]+'.jpg")',
			'background-size': '100%',
			'background-repeat': "no-repeat"
		});
		$(".feature-box").fadeIn(1500);
	}
	//Displays the first featured member randomly. Also fills in the members section randomly.
	function initialize(){
		var num = Math.floor((Math.random()*10)+1);
		for (var i=num;i<num+10;i++){
			if (i%10 !== 0){
				list((i%10).toString());
				swap(i%10);
			}
		}
		feature();
	}
	$(".feature-box").hide();
	$(".members").hide();
	var initialized = false;
	var buffer = 200; //to start the initializing
	$(window).scroll(function() {
		if (!initialized && ($("#members").offset().top - $(window).scrollTop() < buffer)){
	 		initialize();
	 		initialized= true;
	 	}
		// }else if (initialized && ($("#members").offset().top - $(window).scrollTop() > buffer*2)){
		// 	$(".feature-box").hide();
		// 	$(".members").hide();
		// 	initialized = false;
		// }
	});
	$(".scroll").click(function(event){
		//prevent the default action for the click event
		event.preventDefault();

		//get the full url - like mysitecom/index.htm#home
		var full_url = this.href;

		//split the url by # and get the anchor target name - home in mysitecom/index.htm#home
		var parts = full_url.split("#");
		var trgt = parts[1];
		if (trgt ==="members"){
			initialize();
		}
		//get the top offset of the target anchor
		var target_offset = $("#" + trgt).offset();
		var target_top = target_offset.top;

		//goto that anchor by setting the body scroll top to anchor top
		$('html, body').animate({scrollTop: target_top}, 400);
	});
	$(".member").click(function(event){
		var id = $(this).attr('id');
		list(id);
		swap(parseInt(id));
		feature();
	});
});

