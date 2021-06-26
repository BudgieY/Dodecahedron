require_relative './quaternion'
require 'gtk3'

class Context3d
    attr_accessor :context, :q, :qlight, :r, :g, :b

    def initialize(context=nil, q=Quaternion.new(1, 0, 0, 0), qlight=Quaternion.new(0, -1, -1, 1))
        @context = context
        @q = q
        @qlight = qlight
        @r = 1.0;
        @g = 1.0;
        @b = 1.0;
    end

    def set_light_color(r, g, b)
        @r = r;
        @g = g;
        @b = b;
    end

    def clear(r, g, b)
        context.set_source_rgb(r, g, b)
        context.paint 1.0
    end

    def move_to(qp)
        aq = @q * qp * (@q.inv);
        context.move_to(aq.i, aq.j)
    end

    def line_to(qp)
        aq = @q * qp * (@q.inv);
        context.line_to(aq.i, aq.j)
    end

    def set_brightness(q)
        brightness = 0.5+0.5*(@q*(q.im)*(@q.inv)*qlight).normalize.r
        context.set_source_rgb(@r*brightness, @g*brightness, @b*brightness)
    end
end

module Draw3d
    def p_to_q(x, y)
        r = x*x+y*y
        if(r > 1.0)
            r = Math::sqrt(r)
            x /= r
            y /= r
            z = 0.0
        else
            z = Math::sqrt(1.0-r*r)
        end
        Quaternion.new(0, x, y, z)
    end
    module_function :p_to_q
end