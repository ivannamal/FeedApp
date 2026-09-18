import UIKit

final class RemoteImageView: UIImageView {
    private static let cache = NSCache<NSURL, UIImage>()
    private var currentURL: URL?

    func setImage(from urlString: String) {
        guard let url = URL(string: urlString) else { image = nil; return }
        currentURL = url
        if let cached = Self.cache.object(forKey: url as NSURL) {
            image = cached
            return
        }
        image = nil
        Task { [weak self] in
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let img = UIImage(data: data) else { return }
            Self.cache.setObject(img, forKey: url as NSURL)
            await MainActor.run {
                guard let self, self.currentURL == url else { return }
                self.image = img
            }
        }
    }
}
