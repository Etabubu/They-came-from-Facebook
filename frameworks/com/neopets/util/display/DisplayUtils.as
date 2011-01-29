// This class holds useful functions for dealing with Display Objects.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.display
{
	
	import flash.display.*;
	import flash.geom.Rectangle;
	
	public class DisplayUtils {
		
		// This function enables bitmap caching for all display object which don't 
		// contain animations.  The function is recursively applied to the target's 
		// children, so at least part of a given animation will usually be cached by 
		// this function.
		public static function cacheImages(dobj:DisplayObject):void {
			if(dobj == null) return;
			dobj.cacheAsBitmap = true; // enable caching by default
			// apply class specific tests
			if(dobj is DisplayObjectContainer) {
				// if the display object is a container, apply caching to it's children.
				var cont:DisplayObjectContainer = dobj as DisplayObjectContainer;
				var child:DisplayObject;
				for(var i:int; i < cont.numChildren; i++) {
					child = cont.getChildAt(i);
					if(child != null) {
						cacheImages(child);
						// if any child can't be cached, don't cache the container
						if(child.cacheAsBitmap == false) cont.cacheAsBitmap = false;
					}
				}
				// if the container is a movieclip, make sure it's not animated.
				if(cont.cacheAsBitmap) {
					if(cont is MovieClip) {
						var clip:MovieClip = cont as MovieClip;
						if(clip.totalFrames > 1) clip.cacheAsBitmap = false;
					}
				} // end of movie clip test
			} // end of container test
		}
		
		// Use this function to move the target container's children so that the
		// target's bounds are centered around the origin.
		public static function centerChildren(cont:DisplayObjectContainer):void {
			if(cont == null) return;
			var bb:Rectangle = cont.getRect(cont);
			if(bb != null) {
				var dx:Number = -bb.width/2 - bb.left;
				var dy:Number = -bb.height/2 - bb.top;
				cont.x -= dx;
				cont.y -= dy;
				var child:DisplayObject;
				for(var i:int = 0; i < cont.numChildren; i++) {
					child = cont.getChildAt(i);
					child.x += dx;
					child.y += dy;
				}
			}
		}
		
		// This function checks all ancenstor (parents, parent's parents, ect..) for an instance
		// of the target class.
		public static function getAncestorInstance(dobj:DisplayObject,class_def:Class):DisplayObjectContainer {
			// check the parameters
			if(class_def == null || dobj == null) return null;
			// search ancestors
			var ancestor:DisplayObjectContainer = dobj.parent;
			while(ancestor != null) {
				if(ancestor is class_def) return ancestor;
				ancestor = ancestor.parent;
			}
			return null;
		}
		
		// This retutns all children of the container that are also members of the target class.
		public static function getChildInstances(container:DisplayObjectContainer,class_def:Class):Array {
			// check the parameters
			if(class_def == null || container == null) return null;
			// search our children
			var list:Array = new Array();
			var child:DisplayObject;
			for(var i:int = 0; i < container.numChildren; i++) {
				child = container.getChildAt(i);
				if(child is class_def) list.push(child);
			}
			return list;
		}
		
		// This function checks all descendants (children, children's children, ect..) for an instance
		// of the target class.
		public static function getDescendantInstance(container:DisplayObjectContainer,class_def:Class):DisplayObject {
			// check the parameters
			if(class_def == null || container == null) return null;
			// search our children
			var child:DisplayObject;
			var child_container:DisplayObjectContainer;
			var descendant:DisplayObject;
			for(var i:int = 0; i < container.numChildren; i++) {
				child = container.getChildAt(i);
				if(child is class_def) return child;
				// check descendants of child
				if(child is DisplayObjectContainer) {
					child_container = child as DisplayObjectContainer;
					descendant = getDescendantInstance(child_container,class_def);
					if(descendant != null) return descendant;
				}
			}
			return null;
		}
		
		// This function tries to find the url of the swf which contains the target object.
		public static function getRootURL(dobj:DisplayObject):String {
			// check if we have a valid root
			if(dobj == null) return null;
			if(dobj.root == null) return null;
			// check the root's loader info
			var info:LoaderInfo = dobj.root.loaderInfo;
			if(info != null) return info.loaderURL;
			else return null;
		}
		
		// This function checks the target's parent for a child of the given class.
		// If the "use_ancestors" flag is set the check will recurse through the parent's 
		// parent up through the root.
		// If the "use_descendants" flag is set sibling's descendants are also searched.
		public static function getSiblingInstance(dobj:DisplayObject,class_def:Class,use_ancestors:Boolean=false,
												  use_descendants:Boolean=false):DisplayObject {
			// check the parameters
			if(class_def == null || dobj == null) return null;
			// check our parent
			var container:DisplayObjectContainer = dobj.parent;
			if(container != null) {
				if(container is class_def) return container;
				// check all siblings
				var sib:DisplayObject;
				var sib_container:DisplayObjectContainer;
				var match:DisplayObject;
				for(var i:int = 0; i < container.numChildren; i++) {
					sib = container.getChildAt(i);
					if(sib != dobj) {
						if(sib is class_def) return sib;
						// check sibling descendants
						if(use_descendants) {
							if(sib is DisplayObjectContainer) {
								sib_container = sib as DisplayObjectContainer;
								match = getDescendantInstance(sib_container,class_def);
								if(match != null) return match;
							}
						}
					}
				}
				// check for more distantly related relatives
				if(use_ancestors) {
					match = getSiblingInstance(container,class_def,use_ancestors,use_descendants);
					if(match != null) return match;
				}
			}
			return null;
		}
		
		// This function lets you apply a set of callback functions to all a given 
		// display object container's contents.
		// "before_func" starts at the least nested level and works it's way down 
		// (parent first, then children), while "after_function" start at the most 
		// nested level and works it's way back up (children before parents).
		public static function forAllDescendants(cont:DisplayObjectContainer,before_func:Function,
												 bf_params:*=null,after_func:Function=null,af_params:*=null):void
		{
			var child:DisplayObject;
			for(var i:int = 0; i < cont.numChildren; i++) {
				child = cont.getChildAt(i);
				if(before_func != null) before_func(child,bf_params);
				if(child is DisplayObjectContainer) {
					forAllDescendants(child as DisplayObjectContainer,before_func,bf_params,after_func,af_params);
				}
				if(after_func != null) after_func(child,af_params);
			}
		}
		
	}
}