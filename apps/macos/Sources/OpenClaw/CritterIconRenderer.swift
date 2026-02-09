import AppKit

enum CritterIconRenderer {
    private static let size = NSSize(width: 22, height: 22)

    struct Badge {
        let symbolName: String
        let prominence: IconState.BadgeProminence
    }

    private struct Canvas {
        let w: CGFloat
        let h: CGFloat
        let stepX: CGFloat
        let stepY: CGFloat
        let snapX: (CGFloat) -> CGFloat
        let snapY: (CGFloat) -> CGFloat
        let context: CGContext
    }

    private struct Geometry {
        let headRect: CGRect
        let beardRect: CGRect
        let hatBaseRect: CGRect
        let hatTopRect: CGRect
        let hatBandRect: CGRect
        let eyeY: CGFloat
        let eyeOffset: CGFloat
        let eyeW: CGFloat

        init(canvas: Canvas, legWiggle: CGFloat, earWiggle: CGFloat, earScale: CGFloat) {
            let w = canvas.w
            let h = canvas.h
            let snapX = canvas.snapX
            let snapY = canvas.snapY

            // Paddy's Head (Humanoid)
            let headW = snapX(w * 0.60)
            let headH = snapY(h * 0.45)
            let headX = snapX((w - headW) / 2)
            let headY = snapY(h * 0.25)
            self.headRect = CGRect(x: headX, y: headY, width: headW, height: headH)

            // The Great Orange Beard
            let beardW = snapX(headW * 1.2)
            let beardH = snapY(headH * 0.6)
            let beardX = snapX((w - beardW) / 2)
            let beardY = snapY(headY - beardH * 0.4)
            self.beardRect = CGRect(x: beardX, y: beardY, width: beardW, height: beardH)

            // Leprechaun Top Hat
            let hatW = snapX(w * 0.85)
            let hatBaseH = snapY(h * 0.12)
            let hatTopW = snapX(w * 0.55)
            let hatTopH = snapY(h * 0.38)
            let hatX = snapX((w - hatW) / 2)
            let hatTopX = snapX((w - hatTopW) / 2)
            let hatY = snapY(headY + headH - 1)
            
            self.hatBaseRect = CGRect(x: hatX, y: hatY, width: hatW, height: hatBaseH)
            self.hatTopRect = CGRect(x: hatTopX, y: hatY + hatBaseH, width: hatTopW, height: hatTopH)
            self.hatBandRect = CGRect(x: hatTopX, y: hatY + hatBaseH, width: hatTopW, height: snapY(hatTopH * 0.35))

            self.eyeW = snapX(headW * 0.2)
            self.eyeY = snapY(headY + headH * 0.55)
            self.eyeOffset = snapX(headW * 0.26)
        }
    }

    private struct FaceOptions {
        let blink: CGFloat
    }

    static func makeIcon(
        blink: CGFloat,
        legWiggle: CGFloat = 0,
        earWiggle: CGFloat = 0,
        earScale: CGFloat = 1,
        earHoles: Bool = false,
        eyesClosedLines: Bool = false,
        badge: Badge? = nil) -> NSImage
    {
        guard let rep = self.makeBitmapRep() else {
            return NSImage(size: self.size)
        }
        rep.size = self.size

        NSGraphicsContext.saveGraphicsState()
        defer { NSGraphicsContext.restoreGraphicsState() }

        guard let context = NSGraphicsContext(bitmapImageRep: rep) else {
            return NSImage(size: self.size)
        }
        NSGraphicsContext.current = context
        context.imageInterpolation = .none
        context.cgContext.setShouldAntialias(false)

        let canvas = self.makeCanvas(for: rep, context: context)
        let geometry = Geometry(canvas: canvas, legWiggle: legWiggle, earWiggle: earWiggle, earScale: earScale)

        self.drawLeprechaun(in: canvas, geometry: geometry, earWiggle: earWiggle)
        
        let face = FaceOptions(blink: blink)
        self.drawFace(in: canvas, geometry: geometry, options: face)

        if let badge {
            self.drawBadge(badge, canvas: canvas)
        }

        let image = NSImage(size: size)
        image.addRepresentation(rep)
        image.isTemplate = false // Allow color in menu bar
        return image
    }

    private static func makeBitmapRep() -> NSBitmapImageRep? {
        let pixelsWide = 44
        let pixelsHigh = 44
        return NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: pixelsWide,
            pixelsHigh: pixelsHigh,
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bitmapFormat: [],
            bytesPerRow: 0,
            bitsPerPixel: 0)
    }

    private static func makeCanvas(for rep: NSBitmapImageRep, context: NSGraphicsContext) -> Canvas {
        let stepX = self.size.width / max(CGFloat(rep.pixelsWide), 1)
        let stepY = self.size.height / max(CGFloat(rep.pixelsHigh), 1)
        let snapX: (CGFloat) -> CGFloat = { ($0 / stepX).rounded() * stepX }
        let snapY: (CGFloat) -> CGFloat = { ($0 / stepY).rounded() * stepY }
        return Canvas(w: snapX(size.width), h: snapY(size.height), stepX: stepX, stepY: stepY, snapX: snapX, snapY: snapY, context: context.cgContext)
    }

    private static func drawLeprechaun(in canvas: Canvas, geometry: Geometry, earWiggle: CGFloat) {
        let green = NSColor(red: 0.11, green: 0.37, blue: 0.13, alpha: 1.0).cgColor
        let orange = NSColor(red: 1.0, green: 0.55, blue: 0.0, alpha: 1.0).cgColor
        let skin = NSColor(red: 1.0, green: 0.85, blue: 0.73, alpha: 1.0).cgColor
        let black = NSColor.black.cgColor
        let gold = NSColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0).cgColor

        // 1. Draw Beard
        canvas.context.setFillColor(orange)
        canvas.context.addPath(CGPath(roundedRect: geometry.beardRect, cornerWidth: 6, cornerHeight: 6, transform: nil))
        canvas.context.fillPath()

        // 2. Draw Head
        canvas.context.setFillColor(skin)
        canvas.context.addPath(CGPath(roundedRect: geometry.headRect, cornerWidth: 4, cornerHeight: 4, transform: nil))
        canvas.context.fillPath()

        // 3. Draw Hat (with wiggle)
        canvas.context.saveGState()
        let midX = canvas.w / 2
        let midY = geometry.hatBaseRect.minY
        canvas.context.translateBy(x: midX, y: midY)
        canvas.context.rotate(by: earWiggle * 0.15) // Hat tilt
        canvas.context.translateBy(x: -midX, y: -midY)

        canvas.context.setFillColor(green)
        canvas.context.addPath(CGPath(roundedRect: geometry.hatBaseRect, cornerWidth: 1, cornerHeight: 1, transform: nil))
        canvas.context.addPath(CGPath(roundedRect: geometry.hatTopRect, cornerWidth: 2, cornerHeight: 2, transform: nil))
        canvas.context.fillPath()

        canvas.context.setFillColor(black)
        canvas.context.addRect(geometry.hatBandRect)
        canvas.context.fillPath()

        let buckleW = geometry.hatBandRect.width * 0.3
        let buckleH = geometry.hatBandRect.height * 0.8
        let buckleRect = CGRect(x: geometry.hatBandRect.midX - buckleW / 2, y: geometry.hatBandRect.midY - buckleH / 2, width: buckleW, height: buckleH)
        canvas.context.setFillColor(gold)
        canvas.context.addRect(buckleRect)
        canvas.context.fillPath()

        canvas.context.restoreGState()
    }

    private static func drawFace(in canvas: Canvas, geometry: Geometry, options: FaceOptions) {
        canvas.context.setFillColor(NSColor.black.cgColor)

        let leftX = canvas.w / 2 - geometry.eyeOffset
        let rightX = canvas.w / 2 + geometry.eyeOffset
        
        let eyeOpen = max(0.1, 1 - options.blink)
        let eyeH = max(1.0, 2.0 * eyeOpen)

        let leftRect = CGRect(x: leftX - geometry.eyeW / 2, y: geometry.eyeY - eyeH / 2, width: geometry.eyeW, height: eyeH)
        let rightRect = CGRect(x: rightX - geometry.eyeW / 2, y: geometry.eyeY - eyeH / 2, width: geometry.eyeW, height: eyeH)

        canvas.context.addEllipse(in: leftRect)
        canvas.context.addEllipse(in: rightRect)
        canvas.context.fillPath()
    }

    private static func drawBadge(_ badge: Badge, canvas: Canvas) {
        let strength: CGFloat = switch badge.prominence {
        case .primary: 1.0
        case .secondary: 0.58
        case .overridden: 0.85
        }
        let diameter = canvas.snapX(canvas.w * 0.48 * (0.92 + 0.08 * strength))
        let margin = canvas.snapX(max(0.45, canvas.w * 0.02))
        let rect = CGRect(x: canvas.w - diameter - margin, y: margin, width: diameter, height: diameter)

        canvas.context.saveGState()
        canvas.context.setShouldAntialias(true)
        canvas.context.saveGState()
        canvas.context.setBlendMode(.clear)
        canvas.context.addEllipse(in: rect.insetBy(dx: -1.0, dy: -1.0))
        canvas.context.fillPath()
        canvas.context.restoreGState()

        canvas.context.setFillColor(NSColor.labelColor.withAlphaComponent(0.85).cgColor)
        canvas.context.addEllipse(in: rect)
        canvas.context.fillPath()

        if let base = NSImage(systemSymbolName: badge.symbolName, accessibilityDescription: nil) {
            let pointSize = max(6.0, diameter * 0.75)
            let config = NSImage.SymbolConfiguration(pointSize: pointSize, weight: .black)
            let symbol = base.withSymbolConfiguration(config) ?? base
            symbol.isTemplate = true
            let symbolRect = rect.insetBy(dx: diameter * 0.18, dy: diameter * 0.18)
            canvas.context.saveGState()
            canvas.context.setBlendMode(.clear)
            symbol.draw(in: symbolRect, from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: nil)
            canvas.context.restoreGState()
        }
        canvas.context.restoreGState()
    }
}
