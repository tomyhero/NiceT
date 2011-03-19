router {
    connect '/' => { controller => 'Root', action => 'index' };
    connect '/api/list/{name:(livedoor|yahoo|goo|infoseek)}/' => { controller => 'API', action => 'list' };
    connect '/api/nice/' => { controller => 'API', action => 'nice' };
};
