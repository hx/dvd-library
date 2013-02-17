(function () {
    "use strict";

    var window = this;
    var patterns = [
        {
            pattern: '(r)?sort/(title|release-date|production-year|genre|media-type|runtime|certification)',
            factory: function (reverse, field) {
                return {
                    type: 'sort',
                    criteria: field,
                    reverse: !!reverse,
                    toString: function () { return (this.reverse ? 'r' : '') + 'sort/' + this.criteria; }
                };
            }
        }, {
            pattern: 'search/(.+)',
            factory: function (term) {
                return {
                    type: 'search',
                    term: window.decodeURIComponent(term),
                    toString: function () { return 'search/' + window.encodeURIComponent(this.term); }
                };
            }
        }, {
            pattern: 'runtime/(\\d+)-(\\d+)',
            factory: function (min, max) {
                var range = [parseFloat(min), parseFloat(max)];
                return {
                    type: 'filter',
                    property: 'runtime',
                    min: Math.min.apply(Math, range),
                    max: Math.max.apply(Math, range),
                    toString: function () { return 'runtime/' + this.min + '-' + this.max; }
                };
            }
        }, {
            pattern: '(certification)/(.*)',
            factory: function (property, value) {
                return {
                    type: 'filter',
                    property: property,
                    value: window.decodeURIComponent(value),
                    toString: function () { return this.property + '/' + window.encodeURIComponent(this.value); }
                };
            }
        }, {
            pattern: '(person|studio|media-type|genre)/(\\d+)',
            factory: function (property, value) {
                return {
                    type: property === 'person' ? property : 'filter',
                    property: property,
                    value: parseInt(value, 10),
                    toString: function () { return this.property + '/' + this.value; }
                };
            }
        }, {
            pattern: '(production-year)(?:-([lg]te?))?/(\\d{4})',
            factory: function (property, comparison, value) {
                return {
                    type: 'filter',
                    property: property,
                    comparison: comparison || '',
                    value: parseInt(value, 10),
                    toString: function () { return this.property + (this.comparison ? '-' + this.comparison : '') + '/' + this.value; }
                };
            }
        }, {
            pattern: '(release-date)(?:-([lg]te?))?/(\\d{4})-(\\d{2})-(\\d{2})',
            factory: function (property, comparison, year, month, day) {
                return {
                    type: 'filter',
                    property: property,
                    comparison: comparison || '',
                    value: new Date(parseInt(year, 10), parseInt(month, 10) - 1, parseInt(day, 10)),
                    toString: function () {
                        return this.property + (this.comparison ? '-' + this.comparison : '') + '/' +
                            this.value.getFullYear() + '-' +
                            ('0' + (this.value.getMonth() + 1)).slice(-2) + '-' +
                            ('0' + this.value.getDate()).slice(-2);
                    }
                };
            }
        }
    ],
        findNextPattern = function (scopeSet, offset) {
            var i, j, match, scope, inner_match;
            if (offset) {
                scopeSet = scopeSet.substr(offset);
            }
            for (i = 0; i < patterns.length; i += 1) {
                match = patterns[i].leftRegex.exec(scopeSet);
                if (match) {
                    scope = match[0];
                    for (j = 0; j < patterns.length; j += 1) {
                        inner_match = patterns[j].midRegex.exec(scope.substr(1));
                        if (inner_match) {
                            scope = scope.substr(0, scope.indexOf(inner_match[0]));
                        }
                    }
                    return [scope, patterns[i]];
                }
            }
            return false;
        },
        sanitize = function (scopes) {
            var j, former, latter,
                i = scopes.length;
            while (--i > 0) {
                latter = scopes[j = i];
                while (j--) {
                    former = scopes[j];
                    if ((former.toString() === latter.toString()) ||
                            (former.type === 'search' && latter.type === 'search') ||
                            (former.type === 'sort' && former.criteria === latter.criteria)) {
                        scopes.splice(j, 1);
                        i -= 1;
                    }
                }
            }
            return scopes;
        },
        pattern,
        i = patterns.length;

    while (i) {
        i -= 1;
        pattern = patterns[i];
        pattern.pattern += '(?=/|$)';
        pattern.midRegex  = new RegExp('/' + pattern.pattern);
        pattern.leftRegex = new RegExp('^' + pattern.pattern);
    }

    (this.DvdLibrary ? this.DvdLibrary.Helpers : this).parseScopes = function (scopeSet) {
        var next, scope, pattern,
            scopes = [],
            offset = 0;
        while (offset < scopeSet.length && (next = findNextPattern(scopeSet, offset))) {
            scope = next[0];
            pattern = next[1];
            offset += scope.length + 1;
            scopes.push(pattern.factory.apply(this, pattern.leftRegex.exec(scope).slice(1)));
        }
        return sanitize(scopes);
    };

}).call(this);