# Broach

Broach is an implementation of the Campfire API. It was written to do
incidental notifications from an application. For instance a Subversion
post-commit hook or a deploy script.

You can find more information about the API on
[the Campfire developer site](http://developer.37signals.com/campfire).

## Say something real quick

The fastest way to say something in a Campfire room is to set the
authentication credentials and use the speak class method.

<pre><code>
Broach.settings = {
  'account' => 'myaccount',
  'token'   => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  'use_ssl' => true
}
Broach.speak('Office', 'Manfred just deployed a new version of the weblog (http://www.fngtps.com)')
</code></pre>

## Install

The easiest way to install Broach and its dependencies is to install the gem.

<pre><code>$ gem install broach</code></pre>

## Contributors

Eloy Duran <eloy@fngtps.com>
Ilya Sabanin <ilya.sabanin@gmail.com>
Todd Eichel <todd@toddeichel.com>
Anton Mironov <ant.mironov@gmail.com>