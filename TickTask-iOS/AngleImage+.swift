//
//  Image+.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/24/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreData
import UIKit

extension AngleImage
{
    static func image(with angle: CGFloat, color: String) -> AngleImage?
    {
        let request: NSFetchRequest<AngleImage> = AngleImage.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "angle == %@", angle),
            NSPredicate(format: "color == %@", color)
            ])
        
        do
        {
            let result = try Model.context.fetch(request)
            return result.first
        }
        catch
        {
            print("Error fetching: \(error)")
        }
        return nil
    }
}
