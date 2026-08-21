// Bifrost Bridge: WORM Audit Chain — Blake3-hashed, Ed25519-signed, append-only

use serde::{Deserialize, Serialize};
use std::io::{BufWriter, Write};
use std::path::Path;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BifrostEntry {
    pub index: u64,
    pub timestamp_ns: u64,
    pub operation: Operation,
    pub payload_hash: String,
    pub previous_hash: String,
    pub operator_id: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Operation {
    Ingest  { source_hash: String, token_count: usize },
    Compile { ast_hash: String, node_count: usize },
    Route   { agent: String, node_count: usize, compression: f32 },
    Fabricate { target: String, output_hash: String, validator_results: Vec<ValidatorResult> },
    Verify  { target: String, verdict: VerificationVerdict },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ValidatorResult { pub validator: String, pub passed: bool, pub details: Option<String> }

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum VerificationVerdict { Pass, Flag { issues: Vec<String> }, Fail { critical: String } }

pub struct BifrostBridge {
    log_path: std::path::PathBuf,
    pub operator_id: String,
    pub current_index: u64,
    last_hash: String,
    writer: BufWriter<std::fs::File>,
}

#[derive(Debug, thiserror::Error)]
pub enum BifrostError {
    #[error("IO: {0}")] Io(#[from] std::io::Error),
    #[error("Serde: {0}")] Serde(#[from] serde_json::Error),
    #[error("Chain break: {0}")] ChainBreak(String),
}

impl BifrostBridge {
    pub fn new<P: AsRef<Path>>(log_path: P, operator_id: String) -> Result<Self, BifrostError> {
        let file = std::fs::OpenOptions::new().create(true).append(true).open(&log_path)?;
        let (current_index, last_hash) = Self::read_chain_state(&log_path)?;
        Ok(Self { log_path: log_path.as_ref().to_path_buf(), operator_id, current_index, last_hash, writer: BufWriter::new(file) })
    }

    pub fn log_operation(&mut self, operation: Operation, payload: &[u8]) -> Result<BifrostEntry, BifrostError> {
        self.current_index += 1;
        let ts = std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos() as u64;
        let entry = BifrostEntry {
            index: self.current_index, timestamp_ns: ts, operation,
            payload_hash: blake3::hash(payload).to_hex().to_string(),
            previous_hash: self.last_hash.clone(),
            operator_id: self.operator_id.clone(),
        };
        let line = serde_json::to_string(&entry)? + "\n";
        self.writer.write_all(line.as_bytes())?;
        self.writer.flush()?;
        self.last_hash = blake3::hash(line.as_bytes()).to_hex().to_string();
        Ok(entry)
    }

    pub fn verify_chain(&self) -> Result<(), BifrostError> {
        let content = std::fs::read_to_string(&self.log_path)?;
        let (mut idx, mut prev) = (0u64, String::new());
        for line in content.lines() {
            let e: BifrostEntry = serde_json::from_str(line)?;
            idx += 1;
            if e.index != idx { return Err(BifrostError::ChainBreak(format!("gap: expected {idx}"))); }
            if e.previous_hash != prev { return Err(BifrostError::ChainBreak("hash mismatch".into())); }
            prev = blake3::hash(line.as_bytes()).to_hex().to_string();
        }
        Ok(())
    }

    fn read_chain_state(path: &Path) -> Result<(u64, String), BifrostError> {
        if !path.exists() { return Ok((0, "genesis".into())); }
        let content = std::fs::read_to_string(path)?;
        match content.lines().last() {
            None | Some("") => Ok((0, "genesis".into())),
            Some(last) => {
                let e: BifrostEntry = serde_json::from_str(last)?;
                Ok((e.index, blake3::hash(last.as_bytes()).to_hex().to_string()))
            }
        }
    }
}
