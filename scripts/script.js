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
});
$(window).resize(function(){
	setMinHeight("home");
	setMinHeight("about");
	setMinHeight("members");
	setMinHeight("projects");
	init = ($('.nav')).offset().top;
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
	var names = ["stephen", "spencer", "steven", "jasonkh","jasonku","sherman","phuong", "jessica", "cheylene", "catherine"];
	var fullNames = ["Stephen Ahn", "Spencer Chang", "Steven Chen", "Jason Khoo", "Jason Kung", "Sherman Leung", "Phuong Ngyuen", "Jessica Shen", "Cheylene Tanimoto", "Catherine Zaw"];
	var titles = ["Founding Member", "President", "Founding Member", "Founding Member", "Founding Member", "Secretary","Treasurer", "Founding Member", "Founding Member","Vice-President"];
	var text = ["stephen says...", "spencer says...", "steven says...","jason says...", "jason says...","I'm a computer science major interested in building mobile applications to make healthcare more accessible and medicine more understood. Outside of school, I can be found designing websites, apps, or producing music. I'm excited for the start of this group, and to share my experiences as an unconventional premed.","phuong says...","jessica says...","cheylene says...","catherine says..."]
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
		if (names[0] ==="sherman"){
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

