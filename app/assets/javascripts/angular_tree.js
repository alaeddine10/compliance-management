var app = angular.module('GRC', []);

app.directive("slugtree", function() {
	return {
        template: '<ul id="children_{{prefix}}" class="slugtree"><slugtreenode ng-repeat="node in children"></slugtreenode></ul>'
        ,	replace: true
        ,	transclude: true
        ,	restrict: 'E'
        ,	scope: {
          		tree: '=ngModel'
        	}
        , link : function(scope, el, attrs) {
        	angular.noop();
        }
      };
});

app.directive("slugtreenode", function() {

	return {
		restrict : 'E'
		, template: '<li><div ng-transclude="true"></div></li>'
		, transclude: true
		, replace: true
		, link : function(scope, el, attrs, ctrl) {
			      //Add children by $compiling and doing a new choice directive
      		if (scope.node.children && scope.node.children.length > 0) {
        		var child = $compile('<slugtree ng-model="node"></slugtree>')(scope)
        		el.append(child);
      		}

      		ctrl.render = function(value) {
		        el.html(value);
      		};
		}
	};


});

app.factory("slug", [function($scope) {

    return function slug(obj, cb) {

      var content_id = "content_" + Math.floor(Math.random() * 2821109907456).toString(36);
      obj.content_id = content_id;

      for(var i in obj.object) {
      	obj[i] = obj.object[i];
      }
      delete obj.object;
      cb && cb(obj);
      $(obj.children).each(function(i,o) { slug(o, cb); });

      return obj;
    };

}]);

function Controls($scope, slug) {
    $scope.flat || ($scope.flat = $("[ng-model=flat]").text());
    
    $scope.tree = slug(JSON.parse($scope.flat), function(obj) {
    	if(obj.control) {
	      for(var i in obj.control) {
	      	obj[i] = obj.control[i];
	      }
	      delete obj.control;
    	}
    });

}
Controls.$inject = ["$scope", "slug"];

app.controller("Controls", Controls);