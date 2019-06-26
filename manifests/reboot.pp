define xampl::reboot (
  Optional[String]  $when    = undef,
  Optional[String]  $onlyif  = undef,
  Optional[String]  $unless  = undef,
  Optional[String]  $apply   = undef,
  Optional[String]  $message = undef,
  Optional[Variant[Integer, String]] $timeout = undef,
  Optional[Boolean] $noop    = undef,
) {

  # Allow a reboot only if the opt-in fact has been set
  $noop_metaparam = if ($facts['clientnoop'] == true) {
                      true # Client is running in noop mode; noop=true
                    } elsif ($facts['allow_reboot'] in [true, 'true']) {
                      $noop # Reboot allowed... noop=undef (or possibly Boolean)
                    } else {
                      true # Not allowed to reboot; noop=true
                    }

  reboot { $title:
    name    => $name,
    when    => $when,
    onlyif  => $onlyif,
    unless  => $unless,
    apply   => $apply,
    message => $message,
    timeout => $timeout,
    noop    => $noop_metaparam,
  }

}
