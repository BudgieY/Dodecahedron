class Quaternion
    attr_accessor :r, :i, :j, :k

    def initialize(r, i, j, k)
        @r = r
        @i = i
        @j = j
        @k = k
    end

    def +(other)
        raise TypeError.new('Quaternion calc with non-quaternion') unless other.is_a?(Quaternion)
        ar = @r + other.r
        ai = @i + other.i
        aj = @j + other.j
        ak = @k + other.k
        Quaternion.new(ar, ai, aj, ak)
    end

    def -(other)
        raise TypeError.new('Quaternion calc with non-quaternion') unless other.is_a?(Quaternion)
        ar  = @r  - other.r
        ai  = @i  - other.i
        aj  = @j  - other.j
        ak  = @k  - other.k
        Quaternion.new(ar, ai, aj, ak)
    end

    def *(other)
        raise TypeError.new('Quaternion calc with non-quaternion') unless other.is_a?(Quaternion)
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
        anorm = self.norm_square
        Quaternion.new(@r/anorm, -@i/anorm, -@j/anorm, -@k/anorm)
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
        r_sqrt = Math::sqrt((self.abs()+@r)/2.0)
        Quaternion.new(r_sqrt, @i/2.0/r_sqrt, @j/2.0/r_sqrt, @k/2.0/r_sqrt)
    end
end