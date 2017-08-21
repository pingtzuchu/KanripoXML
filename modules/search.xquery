xquery version "3.1";
import module namespace config="http://exist-db.org/apps/kanripo/config" at "config.xqm";
import module namespace kwic="http://exist-db.org/xquery/kwic";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xhtml";
declare option output:media-type "text/html";


for $hit in collection($config:data-root)//tei:p[ft:query(., "隱公")] 
return
    kwic:summarize($hit, <config width="40"/>)
