# cocoapods-checksui

## Thanks for [square/cocoapods-check](https://github.com/square/cocoapods-check).

cocoapods-checksui displays the differences between locked and remote Pods. It can save time by quickly showing whether it's necessary to run `pod install`. And check commit or tag after run `pod install`.

## Installation

    $ gem install cocoapods-checksui

## Usage

`pod check-sui` will display a list of Pods that will be installed by running `pod install`:

    $ pod check-sui
    ~KNCardComponent, ~KNCommunity
    [!] `pod install` will install 2 Pods.

The symbol before each Pod name indicates the status of the Pod. A `~` indicates a version of a Pod exists locally, but the version specified in `Podfile.lock` is different. Pods that don't require an update will not be listed.

Verbose mode shows a bit more detail:

    $ pod check-sui --verbose
    KNCardComponent locked_commit: a38a24db9660c8d48377c00e508492fc2d36162a -> remote_commit: 08006d30dc2c05215d0a9e1c383a35fbd6235425
    KNCommunity locked_commit: 095d3a2db1bbb0dcc653729c493e7e6cac7209c6 -> remote_commit: 3eb7a3572c54b3be82c4f80ecab7a4680c7811f4
    [!] `pod install` will install 2 Pods.

If no Pods are out of date, then the output looks like:

    $ pod check-sui
    The Podfile's dependencies are satisfied

## Exit Code

If any Pods are out of date, `pod check-sui` will exit with a non-zero exit code. Otherwise it will exit with an exit code of zero.

## License

cocoapods-checksui is under the MIT license. See the [LICENSE](LICENSE) file for details.

