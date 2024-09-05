
# SocialNetworkUIKit App                                   
## <img src = "https://github.com/user-attachments/assets/9d50f6bc-37db-42fb-97fb-8916a54b26ee" width = "50">  Overview

The **SocialNetworkUIKit** app is a simple social networking application that allows users to fetch posts, toggle their favorite status, and manage associated comments. This project uses **Realm** for local data storage and **RxSwift** for reactive programming and UIkit for its display.

## Features

- **Fetch Posts:** Retrieve posts from a network source and save them locally in a Realm database.
- **Toggle Favorite Status:** Mark or unmark posts as favorites, with the changes reflected both in the UI and in the database.
- **Comments Management:** Each post can have associated comments, which are also stored in the Realm database.

## Project Structure

- **Models:**
  - `Post`: Represents a social media post.
  - `Comment`: Represents a comment associated with a post.
- **ViewModels:**
  - `PostsViewModel`: Manages fetching, storing, and updating posts and their associated comments.

## Dependencies

- **RealmSwift:** A mobile database for storing data locally on the device.
- **RxSwift & RxCocoa:** Libraries for reactive programming, used for managing asynchronous events and UI bindings.
- **Combine:** A framework by Apple for handling asynchronous events by combining event-processing operators.

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/socialnetwork.git
   cd socialnetwork
2.  **Do the pod install** 
Install dependencies: Ensure you have CocoaPods installed. Then run:
    pod install
3. Open the generated .xcworkspace file in Xcode.
4. Build and run the app: Select a simulator or your connected device, and press Cmd + R to build and run the app.

## Dependency Versions

- **Xcode:** Xcode 15.4
- **Minimum iOS Version:** iOS 14
- **Alamofire:** 5.9.1
- **Realm:** 10.53.0
- **Cocoapods:** 1.15.2

## Screenshots 

  ## Login Screen
 <img src = "https://github.com/user-attachments/assets/ee4ac3f0-a547-40e6-9e32-fbe96bea331f" alt="App Screenshot" width="250">
- <img src = "https://github.com/user-attachments/assets/e173d6bc-ade8-4ed1-94df-771d1566c4ab" alt="App Screenshot" width="250">![Simulator Screenshot - Clone 1 of iPhone 15 - 2024-09-05 at 19 39 37](https://github.com/user-attachments/assets/1d0e2cb6-50d4-4987-b34a-677a721368cf)
![Simulator Screenshot - Clone 1 of iPhone 15 - 2024-09-05 at 19 39 31]()


  ## Posts Screen
- <img src = "https://github.com/user-attachments/assets/af242b53-25c8-4ce7-b784-59208b398672" alt="App Screenshot" width="250">
- <img src = "https://github.com/user-attachments/assets/865bc860-c90c-41e3-ba77-6ce5f7f5910c" alt="App Screenshot" width="250">

  ## Favorites Screen

- <img src = "https://github.com/user-attachments/assets/1d0e2cb6-50d4-4987-b34a-677a721368cf" alt="App Screenshot" width="250">
- <img src = "https://github.com/user-attachments/assets/1678f004-a850-48b7-b54e-e35d3ecc74f2" alt="App Screenshot" width="250">

## Code Explanation
Post Model

    class Post: Object, Identifiable, Codable {
        @Persisted(primaryKey: true) var id: Int
        @Persisted var title: String
        @Persisted var body: String
        @Persisted var isFavorite: Bool = false
        @Persisted var comments: List<Comment>
    }

- Post: A Realm Object representing a post, containing fields like id, title, body, isFavorite, and a list of comments.

Comment Model

      class Comment: Object, Identifiable, Codable {
          @Persisted(primaryKey: true) var id: Int
          @Persisted var name: String
          @Persisted var email: String
          @Persisted var body: String
      }

- Comment: A Realm Object representing a comment, containing fields like id, name, email, and body.

PostsViewModel

     // MARK: - PostsViewModel
/// ViewModel for managing posts and their favorite status.
      class PostsViewModel: PostsViewModelProtocol {
              
          /// Observable array of all posts.
          var postsObservable: Observable<[Post]> {
              postsSubject.asObservable()
          }
          
          /// Observable array of favorite posts.
          var favoritePostsObservable: Observable<[Post]> {
              favoritePostsSubject.asObservable()
          }
          
          /// Private subject to hold the current posts.
          private let postsSubject = BehaviorSubject<[Post]>(value: [])
          
          /// Private subject to hold the current favorite posts.
          private let favoritePostsSubject = BehaviorSubject<[Post]>(value: [])
          
          private let networkManager: NetworkManagerProtocol
          private let realm: Realm
          private let disposeBag: DisposeBag
          
          // MARK: - Initialization
          
          /// Initializes the ViewModel with necessary dependencies.
          /// - Parameters:
          ///   - networkManager: The network manager used for fetching posts.
          ///   - disposeBag: DisposeBag for managing RxSwift subscriptions.
          ///   - realm: Realm database instance.
          init(networkManager: NetworkManagerProtocol = NetworkManager.shared,
               disposeBag: DisposeBag = DisposeBag(),
               realm: Realm = try! Realm()) {
              self.realm = realm
              self.networkManager = networkManager
              self.disposeBag = disposeBag
              fetchLocalPosts()
          }

PostsViewModel: Manages the fetching, storing, and updating of posts and their comments. Uses Realm for local data storage and RxSwift for managing asynchronous events.

## Key Methods:
- fetchPosts(): Fetches posts from the network and stores them in the local Realm database.
- toggleFavorite(post:): Toggles the favorite status of a post.
- fetchLocalPosts(): Retrieves posts from the local Realm database and updates the UI.

## Contributing:
1. Fork the repository
2. Create a new branch: git checkout -b feature-branch-name
3. Commit your changes: git commit -m 'Add some feature'
4. Push to the branch: git push origin feature-branch-name
5. Create a Pull Request


## License:
This project is licensed under the MIT License - see the LICENSE file for details.


