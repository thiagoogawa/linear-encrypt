# Linear Encrypt
An iOS application that encrypts and decrypts characters using the Hill Cipher through matrix operations, connecting theoretical concepts with applied cryptography.

# Preview
![linear](https://github.com/user-attachments/assets/7a92f193-8cce-4596-a208-113969916c8b)


# Technologies Used
* SwiftUI
* Cryptography (Hill Cipher)
* DocC
* Git & GitHub

# Hill Cipher Implementation:

The encryption function validates the cryptographic matrix and message characters, then pads the message to match the matrix size. It converts characters to numbers, organizes them into a matrix, and multiplies the key matrix by the message matrix using modular arithmetic. Finally, it converts the result back to an encrypted string using the formula C = K × M (mod n).
The decryption function works in reverse by converting the encrypted message to numbers and calculating the modular inverse of the key matrix. It then multiplies the inverse matrix by the encrypted matrix (mod n), converts back to string, and removes the padding that was added during encryption, following the formula M = K⁻¹ × C (mod n).

Here's the code:

```swift
    func encrypt(_ message: String) throws -> String {
        guard let matrix = cryptoMatrix else {
            throw CryptoError.matrixNotInitialized
        }
        
        guard CharsetManager.validateMessage(message) else {
            throw CryptoError.invalidCharacters("message contains unsupported characters")
        }
        
        let paddedMessage = MessageProcessor.padMessage(message, to: matrix.size)
        
        guard let numbers = CharsetManager.toNumbers(paddedMessage) else {
            throw CryptoError.encryptionFailed("failed to convert characters")
        }
        
        let messageMatrix = MessageProcessor.organizeToMatrix(numbers, matrixSize: matrix.size)
        let encryptedMatrix = MatrixMath.multiplyMatrices(matrix.values, messageMatrix, mod: CharsetManager.mod)
        let encryptedNumbers = MessageProcessor.flattenMatrix(encryptedMatrix)
        
        return CharsetManager.toString(encryptedNumbers)
    }
    
    func decrypt(_ encryptedMessage: String) throws -> String {
        guard let matrix = cryptoMatrix else {
            throw CryptoError.matrixNotInitialized
        }
        
        guard let numbers = CharsetManager.toNumbers(encryptedMessage) else {
            throw CryptoError.decryptionFailed("message contains invalid characters")
        }
        
        guard let invMatrix = MatrixMath.calculateInverseMatrix(
            matrix.values,
            determinant: matrix.determinant,
            mod: CharsetManager.mod
        ) else {
            throw CryptoError.decryptionFailed("could not calculate inverse matrix")
        }
        
        let encMessageMatrix = MessageProcessor.organizeToMatrix(numbers, matrixSize: matrix.size)
        let decryptedMatrix = MatrixMath.multiplyMatrices(invMatrix, encMessageMatrix, mod: CharsetManager.mod)
        let decryptedNumbers = MessageProcessor.flattenMatrix(decryptedMatrix)
        let decryptedMessage = CharsetManager.toString(decryptedNumbers)
        
        return MessageProcessor.unpadMessage(decryptedMessage)
    }
```
<br>
</br>



# Completeness
Although it's a simple portfolio project, I've implemented the following
* Error handling & alerts
* Empty states
* Text input validation
* Privacy Manifest
* Code documentation (DocC)
* Project organization


