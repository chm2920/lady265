function buttonBoxSubmit(button, formName, action){
	var myHidden = document.createElement('input');
	myHidden.setAttribute('type', 'hidden');
	myHidden.setAttribute('value', 1);
	myHidden.setAttribute('name', button);
	myHidden.setAttribute('ID', 'OpButton');          
	document.getElementById(formName).appendChild(myHidden);          
				
	var myForm = eval('document.'+formName);
	if(action!=''){
		myForm.action=action;
	}
	myForm.submit();
}


function open_details(url, windowname, height) {
	if (!windowname)
		windowname = "task_details";
	if(!height)
		height = 500;
	detailsWindow = window.open(url,windowname,"toolbar=0,location=0,resizable=1,scrollbars=1,width=600,height="+height);
	try {
		detailsWindow.focus();
	} catch(err){
	}
}

function open_help(url) {
	helpWindow = window.open(url,"help_screen","toolbar=0,location=0,resizable=1,scrollbars=1,width=900,height=600");
	helpWindow.focus();
}

function autoFocus(){
	
	var error_control = document.getElementById('__error_control');
	if(error_control && error_control.value!=''){
		var element = document.getElementById(error_control.value);
			if( element && !element.disabled &&
	  		( 
	  			(element.type=='text') ||
					(element.type=='password')
	  		)
	  	){
	  		var err_flag=0;
	    	try {element.focus()}
	    	catch(err){err_flag=1};  				
				return true;
			}
	}
	
	if(document.forms.length){
		outer_loop:		
		for(var i=0; i<document.forms.length; i++){
			for(var j=0; j<document.forms[i].elements.length; j++){
				var element = document.forms[i].elements[j];
        if (element){
        	if((element.name == '_disable_autofocus') &&
          	(element.type == 'hidden') &&
            (element.value == 'yes'))
            return false;
                
					if((element.name) &&
	    			(element.type=='text') ||
    				(element.type=='password')){
	    			if (!element.disabled){
	    				var err_flag=0;
				    	try {element.focus()}
				    	catch(err){err_flag=1};
				    	if(!err_flag){
				    		element.focus();
					    	break outer_loop;
							}
						}
					}
				}
			}
		}
	}
	
}

var Months = new Array ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

//raw_time - for debug purpose only
function browseTimeOffset(raw_time,year,month,day,hour,minute,second, delta){
	var localDateTime = new Date();
    var offset;
	var rawDateTime = new Date(year,month,day,hour,minute,second);
	rawDateTime.setFullYear(year); // years after 2000 dont pass through constructor
    if (delta){
      offset = (Number(delta.substr(1,2))*3600000)+(Number(delta.substr(5,2))*60000);
      if (delta.substr(0,1) == '+') offset = -offset;
    }else{
	  offset = localDateTime.getTimezoneOffset()*60000;
    }
	localDateTime.setTime(rawDateTime.getTime()-offset);
	var localMonth = localDateTime.getMonth()-1;
	localMonth 		= Months[localMonth];
	var localDay 	= _leadZero(localDateTime.getDate());
	var localHour 	= _leadZero(localDateTime.getHours());
	var localMinute = _leadZero(localDateTime.getMinutes());
	var localSecond = _leadZero(localDateTime.getSeconds());
	
	return (localDay+'-'+localMonth+'-'+localDateTime.getFullYear()+' '+localHour+':'+localMinute+':'+localSecond);
	}
	
function _leadZero(num){
	if (String(num).length == 1) num = '0'+num;
	return num;
}

////////////////////////
// cookie_functions.js //
/////////////////////////

// get the value of a cookie by name
function getCookie(name){
	var cname = name + "=";   
	var dc = document.cookie; 

	if (dc.length > 0) {  
		begin = dc.indexOf(cname);   

		if (begin != -1) {   
			begin += cname.length;   
			end = dc.indexOf(";", begin);

			if (end == -1) end = dc.length;

			return unescape(dc.substring(begin, end));
		} 
	}

	return (null);
}

// set a cookie
// accepts name, value, [expires]
// expiry time is set in milliseconds (i.e. 5 seconds = (5*1000))
// if expiry is not set, the cookie will last the life of the session
function setCookie(name, value, expires) {
	var expDate = new Date();
	expDate.setTime(expDate.getTime() + expires);

	document.cookie = name + "=" + escape(value) + "; path=/" + ((expires == null) ? "" : "; expires=" + expDate.toGMTString());
}

// delete a cookie by name
function eatCookie(name) {
	document.cookie = name + "=; expires=Thu, 01-Jan-70 00:00:01 GMT" +  ";	path=/";
}

// BrowserCheck Object
function BrowserCheck(){
  var a = navigator.userAgent
  var b = navigator.appName
  if (b=='Netscape') this.b = 'ns'
  else if (b=='Microsoft Internet Explorer') this.b = 'ie'
  else this.b = b
  this.version = navigator.appVersion
  this.v = parseInt(this.version)
  this.ns = (this.b=='ns' && this.v>=4)
  this.ns4 = (this.b=='ns' && this.v==4)
  this.ns5 = (this.b=='ns' && this.v==5)
  this.ie = (this.b=='ie' && this.v>=4)
  this.ie4 = (this.version.indexOf('MSIE 4')>-1)
  this.ie5 = (this.version.indexOf('MSIE 5')>-1)
  this.ie55 = (this.version.indexOf('MSIE 5.5')>-1)
  this.opera = (a.indexOf('Opera')>-1)
  this.min = (this.ns||this.ie)
}

function flipBlock(id, isrc){
	h=document.getElementById(id);
	h.value=h.value==1?0:1;
	i=document.getElementById(id+'_img');
	i.src=isrc+(h.value==1?'up':'down')+'.gif';
	_v=h.value==1?'none':'block';
	v=h.value==1?'block':'none';
	document.getElementById('show_'+id).style.display=v;
	document.getElementById('hide_'+id).style.display=_v;
}

var browser = null;
function obj_detector() {
	// simplify things
	var agent 	= navigator.userAgent.toLowerCase();
	
	// detect platform
	this.isMac		= (agent.indexOf('mac') != -1);
	this.isWin		= (agent.indexOf('win') != -1);
	this.isWin2k	= (this.isWin && (
			agent.indexOf('nt 5') != -1));
	this.isWinSP2	= (this.isWin && (
			agent.indexOf('xp') != -1 || 
			agent.indexOf('sv1') != -1));
	this.isOther	= (
			agent.indexOf('unix') != -1 || 
			agent.indexOf('sunos') != -1 || 
			agent.indexOf('bsd') != -1 ||
			agent.indexOf('x11') != -1 || 
			agent.indexOf('linux') != -1);
	
	// detect browser
	this.isSafari	= (agent.indexOf('safari') != -1);
	this.isOpera	= (agent.indexOf('opera') != -1);
	this.isNN		= (agent.indexOf('netscape') != -1);
	this.isIE		= (agent.indexOf('msie') != -1);
}
function detector(){
	if(browser == null){
		browser = new obj_detector();
	}
	return browser;
}

function addEventToObject(obj, evt, func) {
	var oldhandler = obj[evt];
	obj[evt] = (typeof obj[evt] != 'function') ? func : function(){oldhandler();func();};
}

function requestContent(url,func,ticketid) {
  if (window.XMLHttpRequest) {
      var req = new XMLHttpRequest();
      if (func) {req.onreadystatechange = function() {func(req);}}
      req.open("GET", url, true);

			var cookieContent = 'vzcpSession='+ticketid+';vzcpTicket='+ticketid+';vzcpLang=en;';
      req.setRequestHeader('Cookie',cookieContent);
      if (detector().isSafari) {req.setRequestHeader('If-Modified-Since','Wed, 15 Nov 1995 00:00:00 GMT');}
      req.send(null);
  } else if (window.ActiveXObject) {
      isIE = true;
	try {var req = new ActiveXObject("Msxml2.XMLHTTP");}
	catch(e) {req = new ActiveXObject("Microsoft.XMLHTTP");}
      if (req) {
          if (func) {req.onreadystatechange = function() {func(req);}}
          req.open("GET", url, true);
          req.send();
      }
  }
}
	
	
function browseCheckAll(element,id){
	for (var i=0;i<document.defaultForm.elements.length;i++){
  	if(document.defaultForm.elements[i].name==id){
			if (!document.defaultForm.elements[i].disabled)
				document.defaultForm.elements[i].checked = element.checked;
  	}
	}
}

function fillCollector(){
	var collector = document.getElementById('collector');
	if(collector){
		var list_inputs = document.getElementsByTagName('input');
		var list_selects = document.getElementsByTagName('select');
		fillCollectorList(list_inputs);
		fillCollectorList(list_selects);
	}
}

function fillCollectorList(list){
	var o;
	var new_list = new Array();
	
	for (var i=0;i<list.length;i++){
		o = list[i];
		if(o.name!='collector'){
			var h = document.createElement('input');
			h.setAttribute('name', '__'+o.name);
	    h.setAttribute('ID', '__'+o.id);          		    		    
	    h.setAttribute('type', 'hidden');		    		    
			
			if(o.type=='checkbox'){
				h.setAttribute('value', o.checked?o.value:'');
			}
			if(o.type=='radio'){
				h.setAttribute('value', o.checked?o.value:'');
			}
			if(o.type=='select-one'){
				h.setAttribute('value', o.selectedIndex>=0?o.options[ o.selectedIndex].value:'');
			}
			if(o.type=='hidden'){
				h.setAttribute('value', o.value);					
			}
			new_list[new_list.length]=h;
		}	
	}			  	
	
	for (var i=0;i<new_list.length;i++){
		document.defaultForm.appendChild(new_list[i]); 
	}
}