require_relative 'quaternion'
require_relative 'draw3d'

class FPentagon
    attr_accessor :points

    def initialize(points)
        @points = points
    end

    def draw(context3d)
        context3d.set_brightness(-self.center)
        context3d.move_to(@points[4])
        for q in @points do
            context3d.line_to(q)
        end
        context3d.context.fill
    end

    def center
        aq = Quaternion.new(0, 0, 0, 0)
        z = Quaternion.new(0.2, 0, 0, 0)
        for q in @points do
            aq = aq + q
        end
        aq * z
    end
end

class Dodecahedron
    attr_accessor :l, :faces
    Phi = (1.0+Math.sqrt(5.0))/2.0

    def initialize(l)
        @l = l
        @faces = Array.new()
        bpoints = Array.new()
        bpoints = bpoints + [[-1.0, 1.0+Phi, 0]]
        bpoints = bpoints + [[-Phi, Phi, Phi]]
        bpoints = bpoints + [[0, 1.0, 1.0+Phi]]
        bpoints = bpoints + [[Phi, Phi, Phi]]
        bpoints = bpoints + [[1.0, 1.0+Phi, 0]]
        12.times do |counter|
            x = counter%2 - 0.5
            y = counter/2%2 - 0.5
            order = counter/4
            fpoint = Array.new(3)
            qs = Array.new()
            bpoints.each do |point|
                fpoint[order%3] = point[0]/2.0*l
                fpoint[(order+1)%3] = point[1]*x*l
                fpoint[(order+2)%3] = point[2]*y*l
                qs = qs + [Quaternion.new(0.0, fpoint[0], fpoint[1], fpoint[2])]
            end
            @faces = @faces + [FPentagon.new(qs)]
        end
    end

    def draw(context3d)
        q = context3d.q
        @faces.sort_by {|face| (q*face.center*(q.inv)).k }.each {|face| face.draw(context3d)}
    end

    private_constant :Phi
end