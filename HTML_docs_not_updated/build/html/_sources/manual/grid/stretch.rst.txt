.. _manual-grid-stretch:

#########
 Stretch
#########

.. function:: stretch(a,n,dom_neg,uni_neg,uni_pos,dom_pos,h_max,h_min,prnt)
    This function determines the uniform and exponential spacing of a 1D grid

    :param n: number of points
    :type n: int
    :param dom_neg: distance to negative domain boundary from origin
    :type dom_neg: real
    :param uni_neg: negative extent of uniform section from origin
    :type uni_neg: real
    :param uni_pos: positive extent of uniform section from origin
    :type uni_pos: real
    :param dom_pos: distance to negative domain boundary from origin
    :type dom_pos: real
    :param h_max: distance to negative domain boundary from origin
    :type h_max: Optional[real]
    :param h_min: distance to negative domain boundary from origin
    :type h_min: Optional[real]
    :rtype: line
