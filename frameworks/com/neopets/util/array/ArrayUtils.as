// This class holds useful functions for dealing with Arrays.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.array
{
	
	public class ArrayUtils {
		
		// This function tries to find a match in the target array for a given item.  As such, 
		// it works much like the "indexOf" function.  However, this function lets you pass in 
		// a "checker" value to control the match criteria.
		// "list" is the array being checked while "itm" is the entry we're looking for.
		// "i" is the index we're trying to add the item at (add to front by default).
		// "checker" is used to determine if another entry matched the one we're trying to add.
		// "checker" can be either a property string or a comparison function.  If left at null 
		// the function just checks if the objects are the same, as per indexOf.
		public static function getMatch(list:Array,itm:Object,checker:*=null):int {
			var entry:Object;
			if(list != null) {
				for(var i:int = 0; i < list.length; i++) {
					entry = list[i];
					// if we have a null item, don't apply checker
					if(itm != null) {
						if(checker != null) {
							// if checker is a function, apply that function
							if(checker is Function) {
								if(checker(itm,entry)) return i;
							} else {
								// otherwise, if checker is a string, treat it like a property id
								if(checker is String) {
									if(itm[checker] == entry[checker]) return i;
								} else if(itm == entry) return i;
							}
						} else {
							// if check is null, just check for matching identities
							if(itm == entry) return i;
						}
					} else {
						// if the item is null, just check if this entry is also null
						if(entry == null) return i;
					}
				} // end of array loop
			}
			return -1;
		}
		
		// Use this function to force a given index into the array's bounds.
		// "i" i the index to be checked and "list" is the array to be checked.
		public static function getValidIndex(i:int,list:Array):int {
			if(list == null) return -1;
			if(i >= 0) {
				if(i >= list.length) return list.length - 1;
				else return i;
			} else {
				// if the value is negative, treat it as counting back from the last element
				i = list.length + i;
				if(i >= 0) return i;
				else return 0;
			}
		}
		
		// This function adds an object to the array another version of that object is not
		// already in the array.
		// "list" is the array being added to while "itm" is the entry we're trying to add.
		// "i" is the index we're trying to add the item at (add to front by default).
		// "checker" is a property string or comparison function used by getMatch.
		public static function insertIfAbsent(list:Array,itm:Object,i:int=0,checker:*=null):void {
			if(list == null) return; // we can't add to a non-existant list;
			if(getMatch(list,itm,checker) >= 0) return; // don't add the item if we already have it
			// treat -1 as adding to the end of the list, -2 as one slot from the end, and so on.
			if(i < 0) i += list.length + 1; // add one for the length of the array after adding the item
			// add the item to the list
			if(i >= 0) {
				if(i < list.length) list.splice(i,0,itm);
				else list.push(itm);
			} else list.unshift(itm);
		}
		
	}
}