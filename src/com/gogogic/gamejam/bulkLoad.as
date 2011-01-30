package com.gogogic.gamejam
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public function bulkLoad(path:String, onReady:Function):void {
		var bulkLoader:BulkLoader = BulkLoader.getLoader( Application.BULK_LOADER_DEFAULT );
		if( !bulkLoader )
			bulkLoader = new BulkLoader( Application.BULK_LOADER_DEFAULT );
		
		if ( bulkLoader.hasItem( path, false )) {
			onReady(bulkLoader, path);
		} else {
			var item:LoadingItem = bulkLoader.add( path, { context: new LoaderContext(true, new ApplicationDomain()) });
			item.addEventListener( BulkLoader.COMPLETE, function():void { 
				item.removeEventListener( BulkLoader.COMPLETE, arguments.callee );
				onReady(bulkLoader, path);
			});
			if (!bulkLoader.isRunning)
				bulkLoader.start();
		}
	}
}