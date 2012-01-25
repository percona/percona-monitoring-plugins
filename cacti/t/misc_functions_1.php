<?php
require('test-more.php');
require('../scripts/ss_get_by_ssh.php');
$debug = true;

is(
   to_float('74900191315.1170664159 dollars per hour'),
   '74900191315.1170664159',
   'to_float 74900191315.1170664159'
);

/* This function was used for diskstats, but then discarded

# ============================================================================
# Divide $left by $right as accurately as possible with reasonable effort.
# ============================================================================
function big_divide ($left, $right) {
   if ( function_exists("bcdiv") ) {
      debug(array('bcdiv', $left, $right, 6));
      return rtrim(bcdiv( $left, $right, 6 ), '0');
   }
   else {
      debug(array('sprintf', $left, $right));
      return rtrim(sprintf(".0f", $left / $right), '0');
   }
}

is(
   big_divide('500000', '128.193474'),
   '3900.354553',
   'big_divide 500000.0/128.193474'
);
*/

is(
   extract_desired(array('items' => 'a1,a2'), 'a1:45 b2:90 a3:0'),
   'a1:45',
   'extract_desired'
);

?>
