---
layout: post
title:  "Named arguments in C"
date:   2017-08-31 21:30:00 +0200
---
{::comment}
vim: set fo=aw2tq, tw=120, spelllang=en
{:/comment}

What if I told you that we can write functions in plain C that support named
arguments, like for example in Scala or Python? Take a look at the following code:

{% highlight c %}
int main() {
  int result;
  // No surprise here
  result = calculate_sum( 3, 4 );
  printf( "%d\n", result ); // prints 7

  // We can explicitly name arguments
  result = calculate_sum( .arg1 = 3, .arg2 = 4 );
  printf( "%d\n", result ); // prints 7

  // When we name arguments, we can also give them in
  // an arbitrary order
  result = calculate_sum( .arg2 = 4, .arg1 = 3 );
  printf( "%d\n", result ); // prints 7

  // Also, we can add optional named arguments
  result = calculate_sum( 3, 4, .subtract_one = true );
  printf( "%d\n", result ); // prints 6

  return 0;
}
{% endhighlight %}

The trick here is to create a structure that can hold the arguments of the call,
and implement the function taking this structure instead of the single
arguments. Then, using a combination of a `#define` with variable arguments that
create a compound literal, we create the façade that is called as if it were the
actual function:

{% highlight c %}
struct _named_t {
  int arg1;
  int arg2;
  bool subtract_one;
};

int _calculate_sum(struct _named_t *args) {
  int result = args->arg1 + args->arg2;
  return args->subtract_one ? result - 1 : result;
}
#define calculate_sum(...) _calculate_sum(&(struct _named_t){ __VA_ARGS__ })
{% endhighlight %}

The struct will live on the caller's stack in this implementation, but you
could also just pass the whole struct into the function, as long as the struct
doesn't contain any arrays that you don't want to copy every time the function
is called.

You can find the whole file in this [gist](https://gist.github.com/atextor/43e4f6313afba84ad6e656c5abba0755).
