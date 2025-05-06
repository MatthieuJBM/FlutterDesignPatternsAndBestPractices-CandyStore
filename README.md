# candy_store

EXPLORING BEYOND .of(context) PATTERN
As we have just learned, if we try to access a widget via .of(context) pattern and the
requested widget is not found in the widget tree, the framework will throw an error. While in
some cases this may be the desired behaviour as it indicates erroneous code, sometime we
may be aware that there is a chance that the widget won’t be present and we know how to
hande that. For that, we have an alternative pattern – .maybeOf(context) – which, instead of throwing an exception, will return a null value if the widget is not present in the widget tree.
You can then handle the null value accordingly. Moreover, accessing MediaQuery via the
generic .of(context) method will trigger rebuilds if any of the property changes, be it
padding, view insets, screen size, and so on. Often, we only care about specific values, so we
can subscribe to specific changes by using specific methods, such as
.paddingOf(context), .sizeOf(context), and so on.

1. .maybeOf(context)

Context contains teh widget, but not he one you expect
For example, this can occur if you use SafeArea in your  widget tree. 
SafeArea overrides MediaQuery and manages its insets.
Therefore, if you attempt to access MediaQuery lower in the tree, you may
receive unexpected results. This can also occur with providers, so make sure
you do not provide the same provider more than once; otherwise, your state
may be inconsistent.

