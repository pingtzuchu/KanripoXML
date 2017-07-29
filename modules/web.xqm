xquery version "3.1";
module namespace web="http://exist-db.org/apps/kanripo/web";

declare variable $web:homepage :=
    <div>
        <h2>Kanripo on eXist-db</h2>
        <div class="alert alert-success">
        <p>歡迎來到Kanripo on eXist-db。本平台設計的目的，在於將Kanripo網站所提供的數位檔案，轉換為TEI/XML，以測試各種數位人文研究的可能。如果你對本站的功能有什麼建議，請隨時使用電子信件連絡本站本站聯絡人<a href="mailto:dh@ptc.cl.nthu.edu.tw">祝平次</a>。</p>
        <p>本文的數位文本，主要來自於<a href="https://www.kanripo.org/">漢リポ Kanseki Repository</a>，並因應研究計畫的需要進行資料加工。一般的資料查詢，直接使用原來漢リポ網站可能會比較方便。本平台則建置在<a href="http://exist-db.org/exist/apps/homepage/index.html">eXist-db</a>開源碼之上。</p>
        </div>
    </div>;
declare variable $web:homepageRight :=
        <p>請點選功能表中的選項，或是利用上列的檢索表單進行本站的檢索。</p>;

declare function web:webpage($leftnode as node(), $rightnode as node(), $titleID as xs:string?){
<div class="row">
        <div class="col-md-9">
           {$leftnode}
        <div class="row">
            <div class="col-md-6">
                <p>本網站網頁利用<a href="http://twitter.github.com/bootstrap/">Bootstrap</a>
                    CSS 資源庫來呈現。</p>
                <p><img width="120px" height="40px" src="http://exist-db.org/exist/apps/homepage/resources/img/existdb.gif" alt="eXist-db"/><a href="http://exist-db.org/exist/apps/homepage/index.html">eXistdb</a> is Open Source Software licensed under the LGPL</p>
                <!--<p>您可以下載本網站所有檔案壓縮檔<a href="https://github.com/duncdrum/ConfucianClassics/releases/latest">cc-XX.xar</a>，並裝到自己設置的eXistdb平台使用。點選連結後，請按左上角下載鍵。目前更新版本2017-07-09。</p>-->
            </div>
            <div class="col-md-6">
                <p>若對本網站有什麼建議指教，歡迎連絡：<a href="mailto:dh@ptc.cl.nthu.edu.tw">祝平次</a>。</p>
                <p><img src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Creative Commons License"/>(c) Kanseki Repository. All content created by us is licensed under a CC BY SA license.</p>
                <p>{current-dateTime()}</p>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        {web:search-form($titleID)}
        {$rightnode}
    </div>
</div>};
declare function web:search-form($titleId as xs:string?){
    <form method="get" action="index.html">
        <h3>請輸入檢索詞：</h3>
        <input name="query" class="col-md-12"/>
        {if ($titleId) then
            <span><input type="hidden" name="titleId"/> {attribute value {$titleId}}</span>
        else ()}
        <input class="btn btn-primary btn-md" type="submit" value="進行檢索"/>　<a href="query.html" style="float:right;" class="btn btn-success btn-md">高級檢索</a>
    </form>
        };
declare variable $web:log :=
    <div>
        <h2>功能日記</h2>
        <ul class="alert alert-success">
            <li>2017-07-09：上傳Kanripo經部資料，重新編寫分層瀏覽，以將檔案結構，調整為以卷為單位。</li>
        </ul>
    </div>;
declare variable $web:roadmap :=
    <div>
        <h2>擬設功能</h2>
        <ol  class="alert alert-success">
            <li>依計畫需求，陸續進行檔案的格式化。</li>
            <li>整合網站書單和四庫書單。</li>
            <li>文字比對，以便自動校勘，以及利用已標點文件處理未標點文件。</li>
        </ol>
    </div>;
