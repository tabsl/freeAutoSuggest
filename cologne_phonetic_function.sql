drop function if exists strip_non_alpha;
drop function if exists soundex_de;
drop function if exists koelner_match;
delimiter $$
create function strip_non_alpha (string varchar(255)) returns varchar(255) 
  deterministic
	begin
		declare res varchar(255) default '';
		set string = lower(string);
		while char_length(string) > 0 do
			if string regexp '^[a-z‰ˆ¸ﬂ]' then
				set res = concat(res, substr(string, 1, 1));
			end if;
			set string = substr(string, 2);
		end while;
		return res;
	end
$$

create function soundex_de (string varchar(255)) returns varchar(255) 
  deterministic
	begin
		declare res varchar(255) default '';
		declare tmp varchar(255) default '';
		declare i tinyint unsigned default 1;
		set string = strip_non_alpha(string);
		while char_length(string) > 0 do
			if string regexp '^[0-9]' then
				set res = concat(res, substr(string, 1, 1));
				set string = substr(string, 2);
			elseif string regexp '^[aeijouy‰ˆ¸ƒ÷‹]' then
				set res = concat(res, '0');
				set string = substr(string, 2);
			elseif string regexp '^ph' then
				set res = concat(res, '3');
				set string = substr(string, 3);
			elseif string regexp '^[bp]' then
				set res = concat(res, '1');
				set string = substr(string, 2);
			elseif string regexp '^[dt][csz]' then
				set res = concat(res, '8');
				set string = substr(string, 3);
			elseif string regexp '^[dt]' then
				set res = concat(res, '2');
				set string = substr(string, 2);
			elseif string regexp '^[fvw]' then
				set res = concat(res, '3');
				set string = substr(string, 2);
			elseif string regexp '^[gkq]' then
				set res = concat(res, '4');
				set string = substr(string, 2);
			elseif string regexp '^c[ahkloqrux]' then
				set res = concat(res, '4');
				set string = substr(string, 2);
			elseif string regexp '^[^sz]c[ahkloqrux]' then
				set string = concat(substr(string, 1, 1), '4', substr(string, 3));
			elseif string regexp '^[^ckq]x+' then
				set tmp = substr(string, 1, 1);
				set string = substr(string, 3);
				while substr(string, 1, 1) = 'x' do
					set string = substr(string, 2);
				end while;
				set string = concat(tmp, 48, string);
			elseif string regexp '^l' then
				set res = concat(res, '5');
				set string = substr(string, 2);
			elseif string regexp '^[mn]' then
				set res = concat(res, '6');
				set string = substr(string, 2);
			elseif string regexp '^r' then
				set res = concat(res, '7');
				set string = substr(string, 2);
			elseif string regexp '^[sz]c' then
				set string = concat(substr(string, 1, 1), '8', substr(string, 3));
			elseif string regexp '^[szﬂ]' then
				set res = concat(res, '8');
				set string = substr(string, 2);
			elseif string regexp '^c[^ahkloqrux]?' then
				set res = concat(res, '8');
				set string = substr(string, 2);
			elseif string regexp '^[ckq]x' then
				set string = concat(substr(string, 1, 1), '8', substr(string, 3));
			else
				set string = substr(string, 2);
			end if;
		end while;
		set res = replace(res, '070', '@');
		set res = replace(res, '07', '0');
		set res = replace(res, '@', '070'); # improved handling of silent r after vowels
		set res = replace(res, '3', '8'); # for phone calls, where F sounds like S
		set tmp = '@';
		while i <= char_length(res) do
			if substr(res, i, 1) = tmp then
				set res = concat(substr(res, 1, i - 1), substr(res, i + 1));
			else
				set tmp = substr(res, i, 1);
				set i = i + 1;
			end if;
			
		end while;
		set res = concat(substr(res, 1, 1), replace(substr(res, 2), '0', ''));
		return res;
	end
$$

create function koelner_match (needle varchar(128), haystack text, splitChar varchar(1)) returns tinyint
  deterministic
  begin
    declare spacePos int;
    declare searchLen int default length(haystack);
    declare curWord varchar(128) default '';
    declare tempStr text default haystack;
    declare tmp text default '';
    declare soundx1 varchar(64) default soundex_de(needle);
    declare soundx2 varchar(64) default '';

    set spacePos = locate(splitChar, tempStr);

    while searchLen > 0 do
      if spacePos = 0 then
        set tmp = tempStr;
        select soundex_de(tmp) into soundx2;
        if soundx1 = soundx2 then
          return 1;
        else
          return 0;
        end if;
      end if;

      if spacePos != 0 then
        set tmp = substr(tempStr, 1, spacePos-1);
        set soundx2 = soundex_de(tmp);
        if soundx1 = soundx2 then
          return 1;
        end if;
        set tempStr = substr(tempStr, spacePos+1);
        set searchLen = length(tempStr);
      end if;

      set spacePos = locate(splitChar, tempStr);

    end while;

    return 0;

  end
$$
delimiter ;
