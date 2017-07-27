xquery version "3.1";

module namespace app="http://exist-db.org/apps/kanripo/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/kanripo/config" at "config.xqm";
import module namespace web="http://exist-db.org/apps/kanripo/web" at "web.xqm";
import module namespace functx="http://www.functx.com" at "functx.xql";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(:page 主頁面唯一程式，擷取網頁變數：coll-資料集、titleID-文本識別碼、path-資料路徑、mode：操作模式選項；之後可以考慮是否以POST傳送，方便傳遞參數:)
declare function app:page($node as node(), $model as map(*), $mode as xs:string?, $path as xs:string?, $titleId as xs:string?, $file as xs:string?){
let $book := (:取得文本資訊:)
    if ($titleId) then doc($config:data-root||"/list.xml")//tei:bibl[data(@n)=$titleId]
    else ()
let $bookTitle := (:文本名稱:)
    if ($book) then data($book/tei:title)
    else ()
let $bookAuthors := (:文本作者:)
    if ($book) then data($book/tei:author)
    else ()
let $titleNode := 
    if ($titleId) then collection($config:data-root||"/kr1/"||$titleId)/tei:TEI
    else ()
let $fileNode := 
    if ($file) then doc($config:data-root||"/kr1/"||$titleId||"/"||$file)/tei:TEI
    else ()
let $currentDiv :=
    if ($path) then app:divPath($fileNode/tei:text/tei:body, $path)
    else if ($fileNode) then  $fileNode/tei:text/tei:body
    else if ($titleNode) then $titleNode/tei:text/tei:body
    else ()
let $leftnode := (:左欄資料:)
    if ($mode eq "54") then $web:roadmap
    else if($mode eq "53") then $web:log
    else if($mode eq "1") then app:bookTitles() (:操作模式1，啟動app:bookTitle功能:)
    else if ($mode eq "2") then app:firstDiv($titleId, $currentDiv, $bookTitle, $file, $path) (:操作模式2，啟動app:firstDiv功能:)
    else $web:homepage
let $rightnode := (:右欄資料:)
    if ($mode eq "54") then <p><br/>左欄是本網站擬設功能，歡迎向本站連絡人提出你想要看到的功能。如果情況允許，我們也會將之納入未來的設計功能當中。</p>
    else if ($mode eq "53") then <p><br/>左欄是目前本網站已完成功能的總表。</p>
    else if ($mode eq "1") then <h4>請點選左邊的書目進行瀏覽</h4>
    else if ($mode eq "2") then 
        if ($path) then app:divHeadOnTheRight($currentDiv, $path, $titleId, $file, $bookTitle)
        else <h4>請點選左邊的項目，以進入下一層目錄。</h4>
    else <p><br/>請點選功能表中的選項，或是利用上列的檢索表單進行本站的檢索。</p>
return
web:webpage($leftnode, $rightnode, $titleId)
};
(:divPath 處理div的路徑:)
declare function app:divPath($node, $path as xs:string?)as node(){
if ($path) then (:如果路徑存在依序處理div:)
    if (count(tokenize($path, "-")) gt 1) then
        app:divPath($node/tei:div[position()=number(substring-before($path, "-"))], substring-after($path, "-"))
    else
        $node/tei:div[position()=number($path)]
else
    $node
}; 
(:製造資料分層標題與超連結:)
declare function app:divHeader($path, $titleId, $currentDiv, $file){
let $pathList := tokenize($path, "-") (:分開路徑的節點:)
let $pathList2 :=
    for $p in 1 to count($pathList) (::)
    return
        <path>{
        let $pathlink :=
            for $q in 1 to $p
            return
                if ($q eq $p) then $pathList[$q]
                else $pathList[$q]||"-"
        return string-join($pathlink)
         }</path>
let $linkFirstPart := (:連結的前面部分:) "index.html?mode=2&amp;titleId="||$titleId||"&amp;file="||$file||"&amp;path="
let $linkList := (:相對於不同標題的連結:)
    for $link at $count in $pathList2
    return $linkFirstPart||$pathList2[$count]
return
    for $div at $count in $currentDiv/ancestor-or-self::tei:div
    return
            <a>{attribute href {$linkList[$count]}}<span>{attribute style {"color:rgb(50,"||string(200-($count - 1)*20)||","||string(200-($count - 1)*30)||")"}}{if ($div/tei:head) then $div/tei:head/text() else "卷首"}</span>/</a>
};
declare function app:firstDiv($titleId, $currentDiv, $bookTitle, $file, $path) as node(){
let $titleUrl := "index.html?mode=2&amp;titleId="||$titleId(:設定連結參數:)
return
    <div>
    <h2><a>{attribute href {$titleUrl}}{$bookTitle}</a>：{app:divHeader($path, $titleId, $currentDiv, $file)}</h2>
    <div class="alert alert-success"> 
    {if ($currentDiv/tei:p) then $currentDiv/tei:p
    else ()}
    {if ($currentDiv/tei:div) then
    <div style="column-count:2;">
    <ol>{
        for $div at $count in $currentDiv/tei:div 
        order by 
            if ($path) then ()
            else base-uri($div)
        return        
        <li>{
            let $urllink :=
                if ($path) then     "index.html?mode=2&amp;titleId="||$titleId||"&amp;file="||$file||"&amp;path="||$path||"-"||$count
                else "index.html?mode=2&amp;titleId="||$titleId||"&amp;file="||tokenize(base-uri($div),"/")[last()]||"&amp;path=1"
            return
                <a> {attribute href {$urllink}} 
                {if ($div/tei:head/text()) then $div/tei:head/text() else <span>{$bookTitle||"卷首"}</span>}</a>}
        </li>
        }
    </ol></div>
    else ()
    }</div>{$currentDiv/tei:byline[last()]}
    </div>
};
declare function app:divHeadOnTheRight($divs, $path, $titleId, $file, $bookTitle) as node(){
let $pathList := tokenize($path, "-")
return
        <div>
        <h4>你也可以從下面點選上一層目錄：</h4>
        <ul>{
            for $div at $count in $divs/../tei:div
            return        
            <li>{
                let $urllink :=
                    if (count($pathList) gt 2) then "index.html?mode=2&amp;titleId="||$titleId||"&amp;file="||$file||"&amp;path="||string-join(remove($pathList, count($pathList)), "-")||"-"||$count
                    else "index.html?mode=2&amp;titleId="||$titleId||"&amp;file="||$file
                return
                    <a> {attribute href {$urllink}} 
                    {$div/tei:head/text()}</a>}
            </li>
            }
        </ul>
        </div>    
};
declare function app:bookTitles(){
    let $data := doc($config:data-root||"/list.xml")/tei:TEI/tei:text/tei:body/tei:listBibl
    return
    <div>
        <h2>目前本站所收經部文本分類如下：</h2>
        <div class="alert alert-success" id="bookList">
            {for $lei at $count in $data/tei:listBibl
            return
                <div>
                    <button style="width:25%;" class="btn btn-info" type="button" data-toggle="collapse"> {attribute data-target {"#list"||$count}}{data($lei/tei:head)}<span class="caret"></span></button>
                    <div class="collapse" style="column-count:3">{attribute id {"list"||$count}}
                    <ol>
                        {for $book in $lei/tei:bibl
                        return
                            <li>{
                                let $titleUrl:="index.html?mode=2&amp;titleId="||data($book/@n)
                                return
                                    <div>
                                        <a>{attribute href {$titleUrl}} {data($book/tei:title)}</a>：
                                        {for $author in $book/tei:author
                                        return
                                            <span><font color="green">{data($book/tei:date)}</font>{data($author/tei:persName)}<font color="red">{$author/text()}</font>　</span>}
                                    </div>
                                }
                            </li>
                        }
                    </ol>
                    </div>
                    <p/>
                </div>
            }
        </div>
    </div>
};
