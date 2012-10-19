<script type="text/javascript">

function autoSuggest() {
  var q = jQuery.trim($('#searchparam').val());
    
  if (q.length >= startSuggest)
  {
    $("#results").hide(); 
   
    $.ajax({
      url: '[{ $oViewConf->getSelfLink() }]cl=autosuggest&q=' + q,
      cache: false,
      dataType: "html",
      type: "get",
      success: function(data){
        if(data) {
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
                
            $.ajax({
            url: '[{ $oViewConf->getSelfLink() }]cl=autosuggest&q=' + q + '&page=' + p,
            cache: false,
            dataType: "html",
            type: "get",
            success: function(data){
              if(data) {
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

</script> 


<form class="search" action="[{ $oViewConf->getSelfActionLink() }]" method="get" name="search">
    <div class="searchBox">
        [{ $oViewConf->getHiddenSid() }]
        <input type="hidden" name="cl" value="search">
        [{block name="header_search_field"}]   
        <input class="textbox innerLabel" type="text" id="searchparam" name="searchparam" title="[{ oxmultilang ident="SEARCH_TITLE" }]" value="Suchbegriff eingeben" autocomplete="off">
        [{/block}]
        <input class="searchSubmit" type="submit" value="">
    </div>
</form>