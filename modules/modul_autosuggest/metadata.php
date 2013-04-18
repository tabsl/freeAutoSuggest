<?php

/**
 * This program is free software;
 * you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation;
 * either version 3 of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>
 */

$aModule = array(
    'id'           => 'modul_autosuggest',
    'title'        => 'Free AutoSuggest with Brain',
    'description'  => 'Fehlertolerante Suche mit automatischen Suchvorschl&auml;gen.',
    'version'      => '3.0',
    'thumbnail'    => 'modul_autosuggest.jpg',
    'author'       => 'OXID Community and <strong style="font-size: 17px;color:#04B431;">e</strong><strong style="font-size: 16px;">ComStyle.de</strong>',
    'email'          => 'info@ecomstyle.de',
    'url'          => 'http://ecomstyle.de',
	 'extend' => array(
		  'oxubase' => 'modul_autosuggest/core/autosuggest'
	 ),
	 'blocks' => array(
		  array('template' => 'widget/header/search.tpl', 'block' => 'widget_header_search_form', 'file' => 'search.tpl'),
	 )
);

