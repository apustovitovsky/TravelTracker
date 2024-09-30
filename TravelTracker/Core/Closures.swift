//
//  Created by Алексей on 22.09.2024.
//

// MARK: - Basic Action

public typealias Action = () -> Void

// MARK: - Basic Handler

public typealias Handler<T> = (T) -> Void

// MARK: - Basic Result Handler

public typealias ResultHandler<T> = (Result<T, Error>) -> Void
