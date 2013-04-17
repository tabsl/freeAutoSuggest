[{if $oView->showSearch() }]
    [{oxscript include="js/widgets/oxinnerlabel.js" priority=10 }]
    [{oxscript add="$( '#searchParam' ).oxInnerLabel();"}]
	[{capture assign=searchScript}]

			function autoSuggest() {
	  var q = jQuery.trim($('#searchparam').val());

	  if (q.length >= startSuggest)
	  {
    	$("#results").hide();
		$image =  $('#wait');
		$image.css({display:'block'});

    	$.ajax({
      url: '[{ $oViewConf->getSelfLink() }]cl=autoSuggest&q=' + q,
      cache: false,
      dataType: "html",
      type: "get",
      success: function(data){
        if(data) {
		  $image.css({display:'none'});
          $("#results").html(" ");
          $("#results").html(data);
          $('#results').show();
          $(".pagination").find("a:eq(0)").addClass("active");
        }
        initPagination(q);
      }
    });

  	} else {
        $('#results').hide();
    	}
	}

	function initPagination(q) {

    $('.pagination li a').click(function() {

        var p = $(this).attr("href");
		$image.css({display:'block'});

            $.ajax({
            url: '[{ $oViewConf->getSelfLink() }]cl=autoSuggest&q=' + q + '&page=' + p,
            cache: false,
            dataType: "html",
            type: "get",
            success: function(data){
              if(data) {
			  	$image.css({display:'none'});
                $("#results").html(" ");
                $("#results").html(data);
                $("#results").show();
                $(".pagination").find("a").removeClass("active");
                $(".pagination").find("a:eq(" + (p-1) + ")").addClass("active");
              }
                initPagination(q);
            }
          });

        return false;
    });
	}
	[{/capture}]

	[{oxstyle include=$oViewConf->getModuleUrl('modul_autosuggest','src/layout.css') }]
	[{oxscript include=$oViewConf->getModuleUrl('modul_autosuggest','src/initall.js') priority=10 }]

[{oxscript add=$searchScript}]
    <form class="search" action="[{ $oViewConf->getSelfActionLink() }]" method="get" name="search">
		<div class="searchBox">
		 	<div id="quicksearch">
				<div id="wait">
		   			<span class="loadimage">
						<img src="[{ $oViewConf->getModuleUrl('modul_autosuggest','src/loading.gif')}]" width="20" alt="" >
					</span>
				</div>
            [{ $oViewConf->getHiddenSid() }]
            <input type="hidden" name="cl" value="search">
            [{block name="header_search_field"}]

			<input type="text" name="searchparam"  value="Suchbegriff eingeben" onblur="if (this.value=='') this.value='Suchbegriff eingeben';" onFocus="if(this.value=='Suchbegriff eingeben') this.value='';" id="searchparam" class="textbox" autocomplete="off" onkeyup="javascript:autoSuggest()">
            [{/block}]
            <input class="searchSubmit" type="submit" value="">
        	</div>
		<div id="results"></div>
        </div>
    </form>
    
[{/if}]
