<?php
/**
 * Plugin Name: CTWP Defaults
 */

function resource_custom_post_type()
{
    register_post_type('resource',
                       array(
                           'labels' => array(
                               'name' => __('Resources'),
                               'singular_name' => __('Resource')
                           ),
                           'public' => true,
                           'has_archive' => true,
                           'show_in_rest' => true,
                           'supports' => array('title')
                       )
    );
}
add_action('init', 'resource_custom_post_type');
?>
