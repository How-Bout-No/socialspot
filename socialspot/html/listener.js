$(function()
{
    window.addEventListener('message', function(event)
    {
		var data = event.data;
		if (!(data.pmsg)) {
			$.expr[':']['hasText'] = function(node, index, props){
				return node.innerText == (props[3]);
			}
			$('.mainc').scrollTop(0);
			var wrap = $('#wrap');
			var contentarea = document.getElementsByClassName('contentarea')[0]
			if (data.meta && data.meta == 'close') {
				contentarea.innerHTML = "";
				$('#wrap').hide();
				return;
			} else if (data.meta && data.meta == 'message') {
				var color = $.parseJSON(data.color);
				var article = document.createElement('article');
				article.className = 'media';
				article.innerHTML = '<figure class="media-left"><p class="image is-96x96"><img src="nui://socialspot/html/img/user_blank.png" style="background-color: rgb('+color+');"></p></figure><div class="media-content"><div class="content"><p><strong>' + data.name + '</strong> <small>@'+data.handle.replace(/\s+/g, '_')+'</small><br>'+data.msg+'</p></div></div>';
				contentarea.insertBefore(article, contentarea.childNodes[0]);
			} else if (data.msglist) {
				var msglist = JSON.parse(data.msglist);
				var msgs = Object.keys(msglist)
				for (i = 0; i < msgs.length; i++) {
					var article = document.createElement('article');
					article.className = 'media';
					article.innerHTML = '<figure class="media-left"><p class="image is-96x96"><img src="nui://socialspot/html/img/user_blank.png" style="background-color: rgb('+msglist[i]['color']+');"></p></figure><div class="media-content"><div class="content"><p><strong>' + msglist[i]['name'] + '</strong> <small>@'+msglist[i]['handle'].replace(/\s+/g, '_')+'</small><br>'+msglist[i]['msg']+'</p></div></div>';
					contentarea.appendChild(article);
				}
			}
			if (data.userlist) {
				var userlist = $.parseJSON(data.userlist);
				$('.users li').remove();
				$.each(userlist, function(i) {
					var li = $('<li/>')
					.html('<a>'+userlist[i][1]+'</a>')
					.appendTo('.users');
				});
			}
			var username = data.user;
			var usercolor = $.parseJSON(data.color);
			var curpm = '';
			$('.users').on('click', 'li', function(){
				if ($(this).text() != username) {
					if (!($(".pmusers").has("li:contains("+$(this).text()+")").length)) {
						$('<li/>').html('<a>'+$(this).text()+'</a>').prop('id', $(this).text().replace(/\s/g, "--")).appendTo('.pmusers');
						$(".pmc").append('<ul class="invis" id="'+$(this).text().replace(/\s/g, "--")+'"><div class="starttext"><p>Starting conversation with '+$(this).text()+'</p></div></ul>');
						$('#pmswitch').click();
						$('.pmusers li#'+$(this).text().replace(/\s/g, "--")).click();
					}
				}
			})
			$('.pmusers').on('click', 'li', function(){
				$('#helptext').addClass("invis");
				$(".pmc ul").addClass("invis");
				$(".pmc ul#"+$(this).text().replace(/\s/g, "--")).removeClass("invis");
				curpm = $(this).text().replace(/\s/g, "--");
				$('#pmmsginput').prop('placeholder', 'Send Message To: '+$(this).text());
			})
			$('#pmsubbut').click(function () {
				if ($('#pmmsginput').val().length > 1) {
					if ($(".pmc ul#"+curpm.replace(/\s/g, "--"))[0].lastChild.children[0].classList.contains('me')) {
						$(".pmc ul#"+curpm.replace(/\s/g, "--"))[0].lastChild.children[0].innerHTML = $(".pmc ul#"+curpm.replace(/\s/g, "--"))[0].lastChild.children[0].innerHTML.replace('</p>', '')+'<br>'+$('#pmmsginput').val()+'</p>';
					} else {
						$(".pmc ul#"+curpm).append('<div class="media-content"><div class="content me" style="border-right: 6px solid rgb('+usercolor+');"><p><strong>'+username+'</strong><br>'+$('#pmmsginput').val()+'</p></div></div>');
					}
					$.post("http://socialspot/data-bus", JSON.stringify({
						message: true, private: true, to: curpm.replace(/--/g, " "), msg: $('#pmmsginput').val()
					}))
					$('#pmmsginput').val('');
				}
			});
			$('#wrap').show();
			$('#msginput').focus();
		} else {
			var color = $.parseJSON(data.color);
			if (!($(".pmusers").has("li:contains("+data.name+")").length)) {
				$('<li/>').html('<a>'+data.name+'</a>').prop('id', data.name.replace(/\s/g, "--")).appendTo('.pmusers');
				$(".pmc").append('<ul class="invis" id="'+data.name.replace(/\s/g, "--")+'"><div class="starttext"><p>Starting conversation with '+data.name+'</p></div></ul>');
			}
			if ($(".pmc ul#"+data.name.replace(/\s/g, "--"))[0].lastChild.children[0].classList.contains('user')) {
				$(".pmc ul#"+data.name.replace(/\s/g, "--"))[0].lastChild.children[0].innerHTML = $(".pmc ul#"+data.name.replace(/\s/g, "--"))[0].lastChild.children[0].innerHTML.replace('</p>', '')+'<br>'+data.msg+'</p>';
			} else {
				$(".pmc ul#"+data.name.replace(/\s/g, "--")).append('<div class="media-content"><div class="content user" style="border-left: 6px solid rgb('+color+');"><p><strong>'+data.name+'</strong><br>'+data.msg+'</p></div></div>');
			}
		}
    }, false);
});
