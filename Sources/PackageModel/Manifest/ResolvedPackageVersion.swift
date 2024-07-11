import Foundation
import struct TSCUtility.Version
// TODO: can't import SourceControl.Revision here because of circular dependency - move SourceControl.Revision to TSC?

/// A resolved package version represents the version of a package that satisfies the dependecy graph requirements.
///
/// A version may not have a revision if it was resolved from a registry. It can also have a branch or a version but not both.
public enum ResolvedPackageVersion: Equatable, Hashable {
    case revision(_ revision: String)
    case version(_ version: Version, revision: String?)
    case branch(_ name: String, revision: String)

    // TODO: are these computed properties confusing?
    public var revision: String? {
        switch self {
        case .revision(let revision):
            return revision
        case .version(_, let revision):
            return revision
        case .branch(_, let revision):
            return revision
        }
    }

    public var branch: String? {
        switch self {
        case .revision, .version:
            return nil
        case .branch(let name, _):
            return name
        }
    }

    public var version: Version? {
        switch self {
        case .revision, .branch:
            return nil
        case .version(let version, _):
            return version
        }
    }
}

extension ResolvedPackageVersion: CustomStringConvertible {
    public var description: String {
        switch self {
        case .revision(let revision):
            return revision
        case .version(let version, _):
            return version.description
        case .branch(let branch, let revision):
            return "\(branch) (\(revision.prefix(7)))"
        }
    }
}

extension ResolvedPackageVersion: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .revision(let revision):
            return revision
        case .version(let version, let revision):
            return "\(version.description) (\(revision ?? "unknown"))"
        case .branch(let branch, let revision):
            return "\(branch) (\(revision))"
        }
    }
}
