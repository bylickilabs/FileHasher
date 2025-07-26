# 🔐 File Hasher (R Version)

|<img width="1280" height="640" alt="r" src="https://github.com/user-attachments/assets/86ec7112-7547-42f5-822f-9a4ead0cdea0" />|
|---|

This is a pure SHA-256 hashing tool written in **R**, capable of processing:

- ✅ Single files
- ✅ Complete directories (recursive)
- ✅ ZIP archives (auto-extracted)
- ✅ RAR archives (requires `unrar` CLI)

<br>

---

<br>

## 🛠️ Requirements

- R 4.x
- Packages: `digest`, `jsonlite`, `tools`
- System dependency for `.rar`: `unrar` must be installed and in PATH

Install required packages:

```yarn
install.packages(c("digest", "jsonlite", "tools"))
```

<br>

---

<br>

## 🚀 Usage

```yarn
Rscript file_hasher.R path/to/file_or_folder_or_archive
```

Outputs a JSON map of paths → SHA-256 hash values.

<br>

---

<br>

**LICENSE:** MIT
[LICENSE](LICENSE)

<br>

---

<br>

**Author:** BYLICKILABS
