<div>
    <form class="searchForm" ng-submit="formSubmit()">
        <div class="search">
            <label> Search: </label>
            <input type="text" ng-model="searchTerm" name="q" search-term-dir>
            <input type="submit" class="submit" value="Search" ng-disabled="!searchTerm">
        </div>
    </form>
    <div class="freq-search">
        <span class="text">Frequently searched terms: </span>
        <a href="javascript:void(0);" ng-click="searchMe($event)"><span>market</span></a>
    </div>
</div>