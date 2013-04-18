<?php
// -------------------------------
// Free Autosuggest 2.0 FOR OXID 4.7x AZURE 2013 PREMIERELINE.DE
// -------------------------------
//Released under the GNU General Public License

class autoSuggest extends oxubase
	{
		public function render()
		{
		$sShopURL = oxConfig::getInstance()->getConfigParam( 'sShopURL' );

		$SQL_FROM = 'SELECT * FROM oxarticles WHERE oxparentid = "" AND oxactive = 1 ';
		$SQL_WHERE = 'oxtitle';

		$searchq		=	strip_tags($_GET['q']);
		$articles_pp = 6;

		$page = !isset($_GET["page"]) ? 1 : intval($_GET["page"]);

		$start =  ($page * $articles_pp) - $articles_pp;

		$dbx = oxDb::getDb()->qstr(''.$searchq.'');
		$getRecord_sql = $SQL_FROM.'AND '.$SQL_WHERE.' LIKE '.oxDb::getDb()->qstr('%'.$searchq.'%').' LIMIT '. $start.' , '. $articles_pp;
		mysql_query( "SET NAMES 'utf8'" ); // Umlaute ausgeben
		$getRecord		=	mysql_query($getRecord_sql);

		$getRecord_sum = $SQL_FROM.'AND '.$SQL_WHERE.' LIKE '.oxDb::getDb()->qstr('%'.$searchq.'%');
		$getRecordsum		=	mysql_query($getRecord_sum);
		if($getRecord) {
		$num_rows1 = mysql_num_rows($getRecordsum);
		$pages_sum = ceil($num_rows1 / $articles_pp);
		}

		if ($num_rows1 == 0) {
		$where_str = "AND ( soundex_match(".$dbx.", oxtitle, ' ') = 1 ) LIMIT ". $start." , ". $articles_pp;

		$getRecord_sql = $SQL_FROM.' '.$where_str;
		$getRecord		=	mysql_query($getRecord_sql);

		$getRecord_sum = $SQL_FROM."AND ( soundex_match(".$dbx.", oxtitle, ' ') = 1 )";
		$getRecordsum		=	mysql_query($getRecord_sum);
		if($getRecord) {
		$num_rows2 = mysql_num_rows($getRecordsum);
		$pages_sum = ceil($num_rows2 / $articles_pp);
		}
		}
		if ($num_rows1 == 0 && $num_rows2 == 0) {
		$where_str = "AND ( koelner_match(".$dbx.", oxtitle, ' ') = 1 ) LIMIT ". $start." , ". $articles_pp;

		$getRecord_sql = 'select * FROM '.$SQL_FROM.' WHERE '. $where_str;
		$getRecord		=	mysql_query($getRecord_sql);

		$getRecord_sum = $SQL_FROM."AND ( koelner_match(".$dbx.", oxtitle, ' ') = 1 )";
		$getRecordsum		=	mysql_query($getRecord_sum);
		if($getRecord) {
		$num_rows3 = mysql_num_rows($getRecord_sum);
		$pages_sum = ceil($num_rows3 / $articles_pp);
		}
		}

		if ($num_rows1 == 0 && $num_rows2 == 0 && $num_rows3 == 0) {
		echo '<table><tr class="first"><td colspan="3"><span style="color:#fff;"><br>Keine Vorschl&auml;ge m&ouml;glich<br><br></span></td></tr>';
                    exit;
		}

        if(strlen($searchq)>0){

        parent::render();
        $oCurr=oxConfig::getInstance()->getActShopCurrencyObject();

        echo '<table><tr class="first"><td colspan="3"><span style="color:#fff;"><br>Vorschl&auml;ge f&uuml;r Ihre Suche:</span></td></tr>';
        while ($row = mysql_fetch_array($getRecord)) {

        $query = "select oxseourl from oxseo where oxobjectid = '" . $row['OXID'] . "' and oxlang = 0 and oxparams IN(select oxid from oxcategories)";
        $result = mysql_query($query);
        while($zeile1 = mysql_fetch_array($result))
        { $seourl = $zeile1['oxseourl'] ;
        }
        $picname = trim(utf8_encode($row['OXPIC1']));
        ?>

        <tr class="resall">
            <td class="title"><?php echo '<a href="/' .$seourl .'">' . $row['OXTITLE'] . '</a>'; ?></td>
            <td class="price"><?php echo number_format($row['OXPRICE'], 2, ",", "").' '.$oCurr->name; ?></td>
            <td class="image"><?php echo '<a class="picture" href="/' .$seourl .'"><img src="'.$sShopURL.'out/pictures/master/product/1/' . $picname . '" alt="' . $row['OXTITLE'] . '" width="30" height="30">'; ?></td>
        </tr>

                <?php }

                if ($pages_sum < 2) {  echo '<tr><td class="pages" colspan="2"></td></tr>'; }
                if ($pages_sum > 10) {  echo '<tr><td class="pages" colspan="2"><span style="color:#fff;"><br>Bitte Ihre Eingabe fortsetzen</span></td></tr>'; }

        if ($pages_sum > 1 AND $pages_sum < 11) {
                echo '<tr><td class="pages" colspan="2"><span style="color:#fff;"><br>Seiten:&nbsp;&nbsp;</span><ul class="pagination">';

            for($i=1; $i<=$pages_sum; $i++)
            {
                  if ($i==$page){
                  echo '<li class="active"><a href="' . $i . '"><span style="padding:7px 10px;border:1px solid #f2f2f2;border-radius: 2px;">' . $i . '</span></a></li>';
				  }
				  else {
				  echo '<li><a href="' . $i . '"><span style="padding:7px 10px;border:1px solid #f2f2f2;border-radius: 2px;">' . $i . '</span></a></li>';
				  }
            }

        echo '</ul></td></tr>';
        }

        echo '</table>';
        exit; // Header-Fehler vermeiden
            } else {
            exit;
            }
        }
    }
?>