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
	$('.email').click(function (){
		$('.emailBox').slideDown();
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


//feature-box javascript
$(document).ready(function($) { 
	var names = ["", "spencer", "steven", "jasonkh","jasonku","sherman","phuong", "jessica", "cheylene", ""];
	var fullNames = ["", "Spencer Chang", "Steven Chen", "Jason Khoo", "Jason Kung", "Sherman Leung", "Phuong Ngyuen", "Jessica Shen", "Cheylene Tanimoto", ""];
	var titles = ["", "President", "Program Development co-chair", "Program Development co-chair", "Publicity Chair", "Secretary","Vice-President", "Events co-chair", "Events co-chair", ""];
	var jessicaText = "Hello! I'm majoring in Biology, with my interest mostly on the organismal scale of things. In my free time, I enjoy playing gigs with my viola and doodling on piano and paper. With the opportunities afforded this organization by its infancy, I'm looking forward to finding and hopefully filling gaps within the community."
	var jasonkuText = "Hello! My name is Jason and I am a 3rd year biology major with a focus on molecular/cellular/developmental biology. In joining APAMSA, I hope to learn more about health care and the issues that affect the API community. Like the other founding members, I am excited to see where this group will go and see how it impacts the university. In my spare time, you can find me planning events, learning graphic design, or enjoying a freshly brewed coffee at a cafe."
	var spencerText = "I’m a Biology major from Portland, Oregon. Starting this organization, I had two things in mind: 1) to foster a community among premeds and those interested in API health issues, and 2) to spread awareness of the many health disparities affecting the API population. I’m interested in the ongoing changes to healthcare and how greater accessibility to healthcare could influence the current outlook on health disparities. Outside of APAMSA, you can find me doing lab research in the Department of Microbiology and Immunology, volunteering at Arbor Free Clinic, drinking coffee, and rooting for the Portland Trailblazers. I am really excited for Stanford Pre-Med APAMSA to make a notable impact on campus and beyond."
	var stevenText = "Hi! I’m looking to pursue a degree in bioengineering then move on to medical school. My academic interests consist of pharmacogenomics and drug development. I really hope that my contribution to this group will help identify and alleviate issue currently and disproportionately affecting Asian Americans. I’m also excited to meet other bright, like-minded individuals! Outside of the classroom, you’ll probably find me at the tennis or squash courts, keeping up with dozens of TV shows, raving (not really) to the latest EDM, or eating. I can’t wait to see the things we can accomplish together."
	var shermanText = "I'm a computer science major interested in building mobile applications to make healthcare more accessible and medicine better understood. Outside of school, I can be found designing websites, apps, or producing music. I'm excited for the start of this group, and to share my experiences as an unconventional premed."
	var phuongText = "I’m a sophomore majoring in Neurobiology, and am excited to see Stanford APAMSA in its first year! From Portland, Oregon, I like to hike and bike in my free time, and it was in my free time that I intern at a lab at a nearby university. It was there where I discovered my interest in neurology, and I hope that she can help others discover new interests this year as well."
	var jasonKhooText = "Hi! I'm a Human Biology major interested in how we can best optimize our health systems to supply the ever increasing demand for affordable health care. I'm particularly excited about how collaboration between health workers, policy writers, and biotech innovators can revolutionize the industry as we know it. Outside of classes you can find me watching a bajillion movies/tv shows, playing hockey, at the squash courts, or obsessing over food. I'm super excited to be working with the awesome team of floating heads on the right to help others on their premed journey."
	var cheyleneText = "I'm majoring in human biology with a focus on bio-medical science. I am interested in providing healthcare to those in need. I am in a polynesian dance group called Kaorihiva and I love to cook and bake. I'm excited to see where this group will go, providing valuable information to premed students and also increasing awareness of Asian American health disparities. "
	var text = ["", spencerText, stevenText,jasonKhooText, jasonkuText,shermanText,phuongText,jessicaText,cheyleneText, ""]
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
		$("#"+id).css({
			'background-image': "url('images/members/circle-"+names[0]+".png')",
			'background-size': '100% 100%'
		});
		$("#"+id).fadeIn(1500);
	}
	function feature(){
		$(".description").html("");
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

