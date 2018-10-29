-- https://cgp.app.box.com/file/333758618591

select * from pageviews;


-- REGEXP_LIKE(language,'言語を選択|請選取語言|Select Language')
-- https://www.ibm.com/support/knowledgecenter/ja/ssw_ibm_i_73/db2/rbafzregexp_like.htm
select
language
,time
,count(time)
from language
where not REGEXP_LIKE(language,'言語を選択|請選取語言|Select Language')
and td_url like '%akiba-bicmap%'
group by td_client_id, time, language
order by time desc


-- TD_TIME_FORMAT(time,'yyyy-MM-dd HH:ss', 'jst')
-- TD_interval(time, '1h')
select TD_TIME_FORMAT(time,'yyyy-MM-dd HH:ss', 'jst') as formatted_time ,*
from used_test_datalayer
--where TD_interval(time, '1h')
order by time desc


-- td_sessionize_window
-- ->TD_SESSIONIZE(time, 3600, ip_address)
-- https://support.treasuredata.com/hc/en-us/articles/360001450828-Supported-Presto-UDFs
-- TD_PARSE_USER_AGENT(td_user_agent,'device')
with d as
(select
  time,
  td_sessionize_window(time, 1800) OVER(
  PARTITION BY td_client_id
  ORDER BY time) as session_id,
 td_client_id,
  case
    when td_os in ('Windows 8.1','Windows 7','Windows 8','Ubuntu', 'Windows XP','Windows Vista', 'FreeBSD', 'Mac OS X') then 'PC'
    when td_user_agent like '%Android%' and td_user_agent like '%Mobile%' then 'mobile'
    when td_user_agent like '%Android%' and not td_user_agent like '%Mobile%' then 'tablet'
    when td_user_agent like '%iPhone%' then 'mobile'
    when td_user_agent like '%iPod%' then 'mobile'
    when td_user_agent like '%iPad%' then 'tablet'
    when td_user_agent like '%Windows Phone%' and td_user_agent like '%Mobile%'then 'mobile'
    when td_user_agent like '%Windows Phone%' and td_user_agent like '%Tablet%'then 'tablet'
    when td_user_agent like '%Firefox%' and td_user_agent like '%Mobile%'then 'mobile'
    when td_user_agent like '%Firefox%' and td_user_agent like '%Tablet%'then 'tablet'
    when regexp_like(td_user_agent, 'Windows NT 10.0|x86_64|Windows NT 6') then 'PC'
    when regexp_like(td_user_agent, 'Mobile Safari|Opera Mini|DoCoMo|UP.Browser|SoftBank|J-PHONE|MOT-|WILLCOM|emobile') then 'mobile'
    when td_os in ('Linux','Other') and TD_PARSE_USER_AGENT(td_user_agent,'device') in ('Motorola', 'Spider') then 'mobile'
    when TD_PARSE_USER_AGENT(td_user_agent,'device') like '%DTV%' then 'TV'
    when TD_PARSE_USER_AGENT(td_user_agent,'device') like '%PlayStation%' then 'game'
    when TD_PARSE_USER_AGENT(td_user_agent,'device') like '%Nintendo%' then 'game'
    ELSE 'PC'
    END as device,
  case
    when REGEXP_LIKE(td_url, '&utm_source=eml|&utm_medium=email|&utm_campaign=\d{6}_sf_') then 'Email'
    when REGEXP_LIKE(td_referrer,'m.facebook.com|t.co|b.hatena.ne.jp|facebook.com|l.facebook.com|lm.facebook.com|linkedin.com|instagram.com|getpocket.com|yammer.com|leoclock.blogspot.jp|plus.url.google.com|slideshare.net|business.facebook.com|reddit.com|l.instagram.com|plus.google.com|twitter.com|workplace.facebook.com|leoclock.blogspot.com|netvibes.com|51z5j2-uwa.netvibes.com|ja-jp.facebook.com|jssst2018.wordpress.com|matome.naver.jp|developers.facebook.com|mobile.twitter.com|mtouch.facebook.com|techcrunchjp.wordpress.com|web.wechat.com|youtube.com') then 'Social'
    when REGEXP_LIKE(td_url, '&utm_source=google|&utm_source=yahoo|&utm_source=gdn|&utm_source=ydn') and REGEXP_LIKE(td_url, '&utm_medium=cpc&|&utm_medium=display&') then 'Paid Search'
    when REGEXP_LIKE(td_referrer, 'google|yahoo|bing|search.smt.docomo|rakuten|ask|biglobe|goo.ne|aol|auone|images.google') and td_referrer like '%search%' then 'Organic Search'
    when td_referrer = '' then 'Direct'
    when td_url like '%&utm_%' then 'Other'
    Else 'Referral' END as referrer
 from tracking
 where td_interval(time,'-2w','jst')
  AND td_referrer not like '%//a.sofmap.com%'
  AND td_browser <> 'YandeBot'
  AND td_browser <> 'FacebookBot'
  AND td_browser <> 'BingPreview'
  AND td_browser <> 'Googlebot'
  AND td_browser <> 'YandexBot'
  AND td_browser <> 'bingbot'
  AND td_host = 'a.sofmap.com'
)

select
TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst') as date
,d.device
,d.referrer
,count(distinct d.session_id) as session_count
,count(distinct d.td_client_id) as uu
from d
group by TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst'), d.device, d.referrer

union all

select
TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst') as date
,d.device
,'subtotal' as referrer
,count(distinct d.session_id) as session_count
,count(distinct d.td_client_id) as uu
from d
GROUP BY d.device, TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst')


union all

select
TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst') as date
,'subtotal' as device
,'subtotal' as referrer
,count(distinct d.session_id) as session_count
,count(distinct d.td_client_id) as uu
from d
GROUP BY TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst')

union all

select
TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst') as date
,'subtotal' as device
,d.referrer
,count(distinct d.session_id) as session_count
,count(distinct d.td_client_id) as uu
from d
GROUP BY d.referrer, TD_TIME_FORMAT(d.time, 'yyyy-MM-dd', 'jst')