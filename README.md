# xampl

A module demonstrating the enableable Puppet code pattern.

This module was created using the Puppet Development Kit (PDK). A short overview of the generated parts can be found in the PDK documentation at https://puppet.com/docs/pdk/1.x/pdk_creating_modules.html.

#### Table of Contents

1. [Description](#description)
2. [Pattern](#pattern)
2. [Usage](#usage)

## Description

The xampl module demonstrates a Puppet code pattern to render selected classes "enableable". This means that the desired state they assert can be turned on or off, on a per-node basis, using class parameters.

In addition to demonstrating the pattern, the module includes examples of tests to assert that a class can be properly enabled or disabled.

## Pattern

The enableable pattern is intentionally simple and has two main elements. 

### Element 1: the `enabled` parameter

First, decide which module class (or classes) are public interfaces and intended to be `include`'d from roles or profiles. Oftentimes, there will only be one public interface class in a module, and it will be the class defined in a module's `init.pp` file.

On these public interface classes, implement the following pattern.

```puppet
class xampl (
  Boolean $enabled = true,
  ...
) {
  if ($enabled) {

    # CONFIGURATION CODE GOES HERE

  }
  else {
    tag 'disabled'
  }
}
```

* Define a Boolean parameter named `enabled`, with a default value – typically `true`.
* The first line of code inside the module's opening curly bracket should be `if ($enabled) { ...`.
* The `if` statement should fully enclose ALL other configuration code in the module.
* The `else` clause should tag the class "disabled".

Note: the else clause exists to aid in querying for and giving visibility into nodes that have disabled classes.

### Element 2: use of `assert_private()`

Private implementation classes should not use the `enabled` parameter and `if` statement. Because these classes cannot be individually enabled or disabled, they should instead use the `assert_private()` function to protect against accidental inclusion from anywhere except the module's public interface classes, which can be enabled or disabled.

```puppet
class xampl::install (
  # Parameters, if any
) {
  assert_private()

  # CONFIGURATION CODE GOES HERE

}
```

## Usage

Enableable classes can be enabled or disabled by setting the Hiera data value for the node. The Hiera key will be of the form `<class_name>::enabled: <true/false>`.

```
xampl::enabled: true
```

```
xampl::enabled: false
```

## Testing

For samples of how to write rspec-puppet tests validating that this pattern is correctly implemented, see the spec files provided.

* spec/classes/xampl\_spec.rb
* spec/classes/install\_spec.rb

## Querying

These examples are in PQL. The same can be accomplished similarly in AST.

List all enableable classes currently disabled, and on how many nodes they are disabled.

```
resources[title, count()] {
  type = "Class" and
  parameters.enabled = false and
  tag = "disabled"
  group by title
}
```

List all nodes for which "Xampl" is disabled.

```
resources[certname] {
  type = "Class" and
  parameters.enabled = false and
  tag = "disabled" and
  title = "Xampl"
}
```

In a single query, return a mixed dataset detailing all nodes with any classes disabled, and which classes those are.

```
resources[certname, title] {
  type = "Class" and
  parameters.enabled = false and
  tag = "disabled"
}
```
