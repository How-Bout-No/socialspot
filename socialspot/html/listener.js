$(function()
{
    window.addEventListener('message', function(event)
    {
		$('.contentarea').scrollTop(0);
        var data = event.data;
        var wrap = $('#wrap');
		var contentarea = document.getElementsByClassName('contentarea')[0]
        if (data.meta && data.meta == 'close') {
            contentarea.innerHTML = "";
            $('#wrap').hide();
            return;
        } else if (data.meta && data.meta == 'message') {
			var colors = ['#00aedb', '#a200ff', '#f47835', '#d41243', '#8ec127'];
			var article = document.createElement('article');
			article.className = 'media';
			var color = colors[data.name.length % 5];
			article.innerHTML = '<figure class="media-left"><p class="image is-64x64"><img src="nui://socialspot/html/img/user_blank.png" style="background-color: '+color+';"></p></figure><div class="media-content"><div class="content"><p><strong>' + data.name + '</strong> <small>@'+data.name.replace(/\s+/g, '_')+'</small><br>'+data.msg+'</p></div><nav class="level is-mobile"></nav></div>';
			contentarea.insertBefore(article, contentarea.childNodes[0]);
			/*
            var div = document.createElement('div');
			div.className = 'content';
			div.innerHTML = '<p><b>' + data.name + '</b><br><p id="text">' + data.msg + '</p></p>';
			contentarea.insertBefore(div, contentarea.childNodes[0]);
			*/
        } else if (data.msglist) {
			console.log(data.msglist);
			var colors = ['#00aedb', '#a200ff', '#f47835', '#d41243', '#8ec127'];
			var msglist = JSON.parse(data.msglist);
			var msgs = Object.keys(msglist)
			for (i = 0; i < msgs.length; i++) {
				var article = document.createElement('article');
				article.className = 'media';
				var color = colors[msglist[i]['name'].length % 5];
				article.innerHTML = '<figure class="media-left"><p class="image is-64x64"><img src="nui://socialspot/html/img/user_blank.png" style="background-color: '+color+';"></p></figure><div class="media-content"><div class="content"><p><strong>' + msglist[i]['name'] + '</strong> <small>@'+msglist[i]['name'].replace(/\s+/g, '_')+'</small><br>'+msglist[i]['msg']+'</p></div><nav class="level is-mobile"></nav></div>';
				contentarea.appendChild(article);
			}
			/*
            var div = document.createElement('div');
			div.className = 'content';
			div.innerHTML = '<p><b>' + data.name + '</b><br><p id="text">' + data.msg + '</p></p>';
			contentarea.insertBefore(div, contentarea.childNodes[0]);
			*/
        }
        $('#wrap').show();
		$('#msginput').focus();
    }, false);
});
