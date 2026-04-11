import CoreGraphics

enum BoundingBoxConverter {
    static func visionNormalizedRectToPDFRect(
        _ normalizedRect: CGRect,
        pageSize: CGSize
    ) -> CGRect {
        CGRect(
            x: normalizedRect.minX * pageSize.width,
            y: (1 - normalizedRect.maxY) * pageSize.height,
            width: normalizedRect.width * pageSize.width,
            height: normalizedRect.height * pageSize.height
        ).integral
    }
}
