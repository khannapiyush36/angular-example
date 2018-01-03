<div>
    <form class="searchForm" action="/content/angular/search-page.html#/results">
        <div class="search">
            <label> Search: </label>
            <input type="text" ng-model="searchTerm" name="q" search-term-dir>
            <input type="submit" class="submit" value="Search" ng-disabled="!searchTerm">
        </div>
    </form>
    <div class="freq-search">
        <span class="text">Frequently searched terms: </span>
        <a href="javascript:void(0);" load-result-page="/results"><span>market</span></a>
    </div>
</div>