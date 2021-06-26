require 'gtk3'
require_relative './utils/draw3d'
require_relative './utils/quaternion'
require_relative './utils/dodecahedron'

builder = Gtk::Builder.new(file: 'test.glade')

window = builder.get_object('Window0')
drawingarea = builder.get_object('DrawingArea0')

$mousex = 0
$mousey = 0
$dragjustbegun = false
$rotateq = Quaternion.new(1.0, 0.0, 0.0, 0.0)
$dodecahedron = Dodecahedron.new(120.0)
$context3d = Context3d.new

def on_win_destroy
    Gtk.main_quit
end

def on_drawingarea_draw(widget, context)
    context.translate(widget.allocated_width/2.0, widget.allocated_height/2.0)

    $context3d.context = context
    $context3d.clear(1.0, 1.0, 1.0)
    $dodecahedron.draw($context3d)
    
    context.destroy
end

def on_drawingarea_dragbegin(widget, context)
    $dragjustbegun = true
end

def on_drawingarea_dragmotion(widget, context, x, y, time)
    if $dragjustbegun then
        $mousex = x
        $mousey = y
        $dragjustbegun = false
        return
    end

    fromi = ($mousex - widget.allocated_width/2.0)/300.0
    fromj = ($mousey - widget.allocated_height/2.0)/300.0
    fromq = Draw3d::p_to_q(fromi, fromj)
    toi = (x - widget.allocated_width/2.0)/300.0
    toj = (y - widget.allocated_height/2.0)/300.0
    toq = Draw3d::p_to_q(toi, toj)

    $rotateq = (-toq*fromq).sqrt*$rotateq
    $context3d.q = $rotateq
    widget.queue_draw

    $mousex = x
    $mousey = y
end

builder.connect_signals{ |handler| method(handler)}

targetentry = Gtk::TargetEntry.new("DrawingArea0", Gtk::TargetFlags::SAME_WIDGET, 0)
drawingarea.drag_source_set(Gdk::ModifierType::BUTTON1_MASK, [targetentry], Gdk::DragAction::PRIVATE)
drawingarea.drag_dest_set(Gtk::DestDefaults::ALL, [targetentry], Gdk::DragAction::PRIVATE)

window.show_all
Gtk.main
