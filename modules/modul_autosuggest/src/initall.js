$(document).ready(function()
{
	var Timer  = '';
	var selecter = 0;
	var Main =0;

	bring(selecter);

    initEvents();
});

// start after user input >= 3 chars
var startSuggest = 1;

/* Init basic events and effects */
function initEvents()
{
    initAutoSuggest();
}

function initAutoSuggest()
{
  $('#searchparam').bind('keyup', function() { autoSuggest(); } );
  $('#searchparam').focus(function() { $('#searchparam').val(" "); } );
  $('#searchparam').blur(function() { $('#searchparam').val("Suchbegriff eingeben"); } );
  $('body').click(function() { $('#results').slideUp(); } );
}

function bring ( selecter )
{
	$('div.shopp:eq(' + selecter + ')').stop().animate({
		opacity  : '1.0',
		height: '60px'

	},300,function(){

		if(selecter < 6)
		{
			clearTimeout(Timer);
		}
	});

	selecter++;
	var Func = function(){ bring(selecter); };
	Timer = setTimeout(Func, 20);
}