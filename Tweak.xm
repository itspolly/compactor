#import <substrate.h>
#import <os/log.h>

#import "pac_helpers.h"

size_t UIApplicationInitialize(void);
void *(*fakeCTFontSetAltTextStyleSpec)(void);

MSHook(size_t, UIApplicationInitialize) {
	size_t orig = _UIApplicationInitialize();
	fakeCTFontSetAltTextStyleSpec();
	return orig;
}

%ctor {
	void *_sym = MSFindSymbol(NULL, "_CTFontSetAltTextStyleSpec");
	if (_sym != NULL) { 
		fakeCTFontSetAltTextStyleSpec = (void *(*)(void))make_sym_callable(_sym);
		MSHookFunction("_UIApplicationInitialize", MSHake(UIApplicationInitialize));
	}
}