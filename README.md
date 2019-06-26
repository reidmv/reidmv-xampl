# xampl

A module demonstrating Puppet code patterns.

This module was created using the Puppet Development Kit (PDK). A short overview of the generated parts can be found in the PDK documentation at https://puppet.com/docs/pdk/1.x/pdk_creating_modules.html.

#### Table of Contents

1. [Description](#description)
2. [xampl-pdk-templates](#xampl-pdk-templates)
3. [Enableable Pattern](#enableable-pattern)
    * [Element 1](#element-1-the-enabled-parameter)
    * [Element 2](#element-2-use-of-assert_private)
    * [Enableable Usage](#enableable-usage)
    * [Enableable Testing](#enableable-testing)
    * [Enableable Querying](#enableable-querying)
4. [Protected Reboot Pattern](#protected-reboot-pattern)
    * [Protected Reboot Usage](#protected-reboot-usage)
    * [Protected Reboot Testing](#protected-reboot-testing)
5. [Enforcing policies](#enforcing-policies)

## Description

The xampl module demonstrates Puppet code and testing patterns. These patterns typically include usage and accompanying rspec-puppet shared example tests which can be incorporated into a CI system to enforce compliance with the patterns.

## xample-pdk-templates

This module uses content which may be common to many modules, in the form of shared rspec-puppet examples. This content is centralized in a PDK templates repo [here](https://github.com/reidmv/xampl-pdk-templates). By using a PDK templates repo, a module can easily be brought up to date with the latest shared content by running `pdk update`.

See also: [pdksync](https://github.com/puppetlabs/pdksync). A tool to manage `pdk update` operations centrally for a large library of modules.

## Enableable Pattern

Enableable is a Puppet code pattern to render selected classes "enableable". This means that the desired state they assert can be turned on or off, on a per-node basis, using class parameters.

The enableable pattern is intentionally simple and has two main elements. 

### Element 1: the `enabled` parameter

First, decide which module class (or classes) are public interfaces and intended to be `include`'d from roles or profiles. Oftentimes, there will only be one public interface class in a module, and it will be the class defined in a module's `init.pp` file.

On these public interface classes, implement the following pattern.

#### Automated implementation

```puppet
class xampl (
  Boolean $enabled = true,
  ...
) {
  xampl::enabled_code() || {

    # CONFIGURATION CODE GOES HERE

  }
}
```

* Define a Boolean parameter named `enabled`, with a default value – typically `true`.
* The first line of code inside the module's opening curly bracket should be `xampl::enabled_code() || {`
* This block should fully enclose ALL other configuration code in the class.

See the function definition [here](lib/puppet/functions/xampl/enabled_code.rb) for full implementation details, or review the manual version below to understand what this will do.

#### Manual implementation

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
* The `if` statement should fully enclose ALL other configuration code in the class.
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

### Enableable Usage

Enableable classes can be enabled or disabled by setting the Hiera data value for the node. The Hiera key will be of the form `<class_name>::enabled: <true/false>`.

```
xampl::enabled: true
```

```
xampl::enabled: false
```

### Enableable Testing

For samples of how to write rspec-puppet tests validating that this pattern is correctly implemented, see the spec files provided.

* [spec/classes/xampl\_spec.rb](spec/classes/xampl_spec.rb)
* [spec/classes/install\_spec.rb](spec/classes/install_spec.rb)
* [spec/shared\_examples.rb](spec/shared_examples.rb)

### Enableable Querying

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

## Protected Reboot Pattern

The protected reboot pattern demonstrates wrapping a reboot resource in a defined type that carefully controls when the nested reboot resource is allowed to be defined in enforcement mode. The resource will be locked to noop mode unless all required conditions are met.

Enforcement of the pattern is accomplished by way of CI and rspec-puppet shared examples.

### Protected Reboot Usage

A protected reboot resource is defined in code using the defined type name, and any valid reboot resource parameters.

```puppet
xampl::reboot { 'protected reboot':
  when => 'refreshed',
}
```

The enforcement behavior of the resulting reboot resource is controlled by a fact value: `facts.allow_reboot`. When this fact is set to Boolean true or String "true", the reboot resource will behave exactly as written. However, if this fact is not set, or set to any value except those already described, the reboot resource created will be hard-locked to `noop` mode.

Normal Puppet runs that do not have a value for this fact will therefore not contain any "live" reboot resources. Any reboot resources that exist will be noop resources.

When it is safe to perform reboots if necessary, invoke Puppet as follows, using an environment variable to set a one-time value for `facts.allow_reboot`.

```
FACTER_allow_reboot=true /opt/puppetlabs/bin/puppet agent -t
```

### Protected Reboot Testing

Making sure the shared examples are available, see for example:

```
describe 'xampl::install' do
  it_behaves_like 'a policy-compliant class'
end
```

* [spec/shared\_examples.rb](spec/shared_examples.rb)
* [spec/classes/install\_spec.rb](spec/classes/install_spec.rb)

## Enforcing Policies

Enforcing that all content pass common requirements can be done at the control-repo level using roles, and [onceover](https://github.com/dylanratcliffe/onceover). Onceover will run a basic test automatically on all roles defined in the control-repo. By default it only checks that the role will compile, but onceover allows the set of required tests to be expanded and can include other shared examples, such as the `it behaves like a policy-compliant class` shared example demonstrated in this module.

For more information, see [https://github.com/dylanratcliffe/onceover#accessing-onceover-in-a-traditional-rspec-test](https://github.com/dylanratcliffe/onceover#accessing-onceover-in-a-traditional-rspec-test).
