# Bundled tools

## `jetbrains-annotations/`

JetBrains ExternalAnnotations XML — bundled BCL purity coverage
consumed by `Semantic.DotNet.JB_ANNOTATIONS`. Not committed to
the repo (~12 MB upstream); `.gitignore`d. The `ghul.ghulproj`
bundles it into the published NuGet via
`tools/$(TargetFramework)/any/jetbrains-annotations/`, and lays
it out alongside the compiler DLL in development builds.

`build/filter-jb-annotations.sh` trims the upstream tarball to
only the `<member>` blocks that carry
`JetBrains.Annotations.PureAttribute` (the only attribute the
compiler reads). That drops ~12 MB to ~1 MB with no behavioural
change.

To populate locally:

```sh
gh api repos/JetBrains/ExternalAnnotations/tarball/master \
  --header "Accept: application/vnd.github.raw" > /tmp/jb-annot.tar.gz
mkdir -p tools/jetbrains-annotations
cd tools/jetbrains-annotations
tar xzf /tmp/jb-annot.tar.gz "JetBrains-ExternalAnnotations-*/Annotations/.NETCore"
mv JetBrains-ExternalAnnotations-*/Annotations/.NETCore/* .
rmdir -p JetBrains-ExternalAnnotations-*/Annotations/.NETCore
cd -
./build/filter-jb-annotations.sh tools/jetbrains-annotations
```

The compiler reads from `<compiler-dir>/jetbrains-annotations` —
the layout the build / publish / pack outputs put together via
the `<Content Link="jetbrains-annotations\…" CopyToOutputDirectory="Always">`
glob in `ghul.ghulproj`. `GHUL_JB_ANNOTATIONS_PATH` overrides for
the rare out-of-tree case. Missing means no JB-coverage upgrade
— every imported BCL method stays at the default IMPURE on the
import side.
