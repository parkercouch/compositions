fn main() {
    tonic_build::compile_protos("proto/sequencer.proto").expect("sequencer proto failed to compile");
}
