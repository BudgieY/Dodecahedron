class Quarternion
    attr_accessor :r, :i, :j, :k

    def initialize(r, i, j, k)
        @r = r
        @i = i
        @j = j
        @k = k
    end

    def +(other)
        fail 'Quarternion calc with non-quarternion' unless other.is_a?(Quarternion)
        ar = @r + other.r
        ai = @i + other.i
        aj = @j + other.j
        ak = @k + other.k
        Quarternion.new(ar, ai, aj, ak)
    end

    def -(other)
        fail 'Quarternion calc with non-quarternion' unless other.is_a?(Quarternion)
        ar  = @r  - other.r
        ai  = @i  - other.i
        aj  = @j  - other.j
        ak  = @k  - other.k
        Quarternion.new(ar, ai, aj, ak)
    end

    def *(other)
        fail 'Quarternion calc with non-quarternion' unless other.is_a?(Quarternion)
        ar = @r*other.r - @i*other.i - @j*other.j - @k*other.k
        ai = @r*other.i + @i*other.r + @j*other.k - @k*other.j
        aj = @r*other.j - @i*other.k + @j*other.r + @k*other.i
        ak = @r*other.k + @i*other.j - @j*other.i + @k*other.r
        Quarternion.new(ar, ai, aj, ak)
    end

    def -@
        Quarternion.new(-@r, -@i, -@j, -@k)
    end

    def norm
        @r*@r + @i*@i + @j*@j + @k*@k
    end

    def conjugate
        Quarternion.new(@r, -@i, -@j, -@k)
    end

    def inv
        anorm = self.norm
        Quarternion.new(@r/anorm, -@i/anorm, -@j/anorm, -@k/anorm)
    end

    def im
        Quarternion.new(0, @i, @j, @k)
    end

    def abs
        Math::sqrt(self.norm)
    end

    def normalize
        aabs = self.abs
        Quarternion.new(@r/aabs, @i/aabs, @j/aabs, @k/aabs)
    end

    def sqrt
        hc = Math::sqrt((1.0+self.normalize.r)/2.0)
        hr = Math::sqrt(self.abs)
        Quarternion.new(hr*hc, @i/hr/hc/2.0, @j/hr/hc/2.0, @k/hr/hc/2.0)
    end
end