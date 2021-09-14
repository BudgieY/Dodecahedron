class Quaternion
    attr_accessor :r, :i, :j, :k

    def initialize(r, i, j, k)
        @r = r
        @i = i
        @j = j
        @k = k
    end

    def +(other)
        fail 'Quaternion calc with non-quaternion' unless other.is_a?(Quaternion)
        ar = @r + other.r
        ai = @i + other.i
        aj = @j + other.j
        ak = @k + other.k
        Quaternion.new(ar, ai, aj, ak)
    end

    def -(other)
        fail 'Quaternion calc with non-quaternion' unless other.is_a?(Quaternion)
        ar  = @r  - other.r
        ai  = @i  - other.i
        aj  = @j  - other.j
        ak  = @k  - other.k
        Quaternion.new(ar, ai, aj, ak)
    end

    def *(other)
        fail 'Quaternion calc with non-quaternion' unless other.is_a?(Quaternion)
        ar = @r*other.r - @i*other.i - @j*other.j - @k*other.k
        ai = @r*other.i + @i*other.r + @j*other.k - @k*other.j
        aj = @r*other.j - @i*other.k + @j*other.r + @k*other.i
        ak = @r*other.k + @i*other.j - @j*other.i + @k*other.r
        Quaternion.new(ar, ai, aj, ak)
    end

    def -@
        Quaternion.new(-@r, -@i, -@j, -@k)
    end

    def norm_square
        @r*@r + @i*@i + @j*@j + @k*@k
    end

    def conjugate
        Quaternion.new(@r, -@i, -@j, -@k)
    end

    def inv
        normsq = self.norm_square
        Quaternion.new(@r/normsq, -@i/normsq, -@j/normsq, -@k/normsq)
    end

    def im
        Quaternion.new(0, @i, @j, @k)
    end

    def abs
        Math::sqrt(self.norm_square)
    end

    def normalize
        aabs = self.abs
        Quaternion.new(@r/aabs, @i/aabs, @j/aabs, @k/aabs)
    end

    def sqrt
        hc = Math::sqrt((1.0+self.normalize.r)/2.0)
        hr = Math::sqrt(self.abs)
        Quaternion.new(hr*hc, hr*@i/hc/2.0, hr*@j/hc/2.0, hr*@k/hc/2.0)
    end
end