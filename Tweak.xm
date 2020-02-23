#import <substrate.h>
#import <os/log.h>

#import "pac_helpers.h"

size_t UIApplicationInitialize(void);
void *(*fakeCTFontSetAltTextStyleSpec)(void);

MSHook(size_t, UIApplicationInitialize) {
	size_t orig = _UIApplicationInitialize();
	if (fakeCTFontSetAltTextStyleSpec != NULL) {
		fakeCTFontSetAltTextStyleSpec();
	}
	return orig;
}

%ctor {
	MSHookFunction("_UIApplicationInitialize", MSHake(UIApplicationInitialize));
	fakeCTFontSetAltTextStyleSpec = (void *(*)(void))make_sym_callable(MSFindSymbol(NULL, "_CTFontSetAltTextStyleSpec"));
}