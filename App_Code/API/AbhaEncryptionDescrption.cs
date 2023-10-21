using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Digests;
using Org.BouncyCastle.Crypto.EC;
using Org.BouncyCastle.Crypto.Engines;
using Org.BouncyCastle.Crypto.Generators;
using Org.BouncyCastle.Crypto.Modes;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Pkcs;
using Org.BouncyCastle.Security;
using Encoder = Org.BouncyCastle.Utilities.Encoders;
using Org.BouncyCastle.Math;
using Org.BouncyCastle.Asn1.X509;
using Org.BouncyCastle.X509;


public class AbhaEncryptionDecrypton
{
    public readonly string CURVE = ABHABasicData.CURVE;
    public readonly string ALGORITHM = ABHABasicData.ALGORITHM;
  
    // Method for encrypting the string
    public string EncryptString(string stringToEncrypt,byte[] xorOfRandoms,string senderPrivateKey,string receiverPublicKey)
    {
        // Generating the shared key using the parameters available
        var sharedKey = "";
        if (receiverPublicKey.Length > 200)
        {
            sharedKey = GetBase64FromByte(GetSharedSecretValue(senderPrivateKey, receiverPublicKey));

        }
        else
        {
            sharedKey = GetBase64FromByte(GetSharedSecretValueForEncryption(senderPrivateKey, receiverPublicKey));

        }
         
        // Generate the salt and IV
        var salt = xorOfRandoms.Take(20);
        var iv = xorOfRandoms.Reverse().Take(12);
        var aesKey = GenerateAesKey(sharedKey, salt);
 
        // Encrypt the data
        var encryptedString = string.Empty;
        try
        {
            var dataBytes = Encoding.UTF8.GetBytes(stringToEncrypt);
            var cipher = new GcmBlockCipher(new AesEngine());
            var parameters =
                new AeadParameters(new KeyParameter(aesKey.ToArray()), 128, iv.ToArray(), null);
            cipher.Init(true, parameters);
            var encryptedBytes = new byte[cipher.GetOutputSize(dataBytes.Length)];
            var returnLengthEncryptedData = cipher.ProcessBytes
                (dataBytes, 0, dataBytes.Length, encryptedBytes, 0);
            cipher.DoFinal(encryptedBytes, returnLengthEncryptedData);
            encryptedString = Convert.ToBase64String(encryptedBytes, Base64FormattingOptions.None);
        }
        catch (Exception ex)
        {
            
        }

        // Return the encrypted string
        return encryptedString;
    }

    // Method for decrypting the string
    public string DecryptString(string stringToDecrypt,
        byte[] xorOfRandoms,
        string receiverPrivateKey,
        string senderPublicKey)
    {
        // Generating the shared key using the parameters available
      //  var sharedKey = GetBase64FromByte(GetSharedSecretValue(receiverPrivateKey, senderPublicKey));

        var sharedKey = "";
        //if (senderPublicKey.Length > 200)
        //{
        //    sharedKey = GetBase64FromByte(GetSharedSecretValue(receiverPrivateKey, senderPublicKey));

        //}
        //else
        //{
        //    sharedKey = GetBase64FromByte(GetSharedSecretValueForEncryption(receiverPrivateKey, senderPublicKey));

        //}

        sharedKey = GetBase64FromByte(GetSharedSecretValueForEncryption(receiverPrivateKey, senderPublicKey));

        Console.WriteLine("DHE SHARED SECRET: " + sharedKey);

        // Generate the salt, IV and aes key
        var salt = xorOfRandoms.Take(20);
        var iv = xorOfRandoms.Reverse().Take(12);
        var aesKey = GenerateAesKey(sharedKey, salt);
      
        // Decrypting the data
        String decryptedData = "";
        try
        {
            var dataBytes = GetByteFromBase64(stringToDecrypt).ToArray();
            var cipher = new GcmBlockCipher(new AesEngine());
            var parameters =
                new AeadParameters(new KeyParameter(aesKey.ToArray()), 128, iv.ToArray(), null);
            cipher.Init(false, parameters);
            byte[] plainBytes = new byte[cipher.GetOutputSize(dataBytes.Length)];
            int retLen = cipher.ProcessBytes
                (dataBytes, 0, dataBytes.Length, plainBytes, 0);
            cipher.DoFinal(plainBytes, retLen);
            decryptedData = Encoding.UTF8.GetString(plainBytes);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        // Returning decrypted data
        return decryptedData;
    }

    // Generating DHE Key
    public AsymmetricCipherKeyPair GenerateKey()
    {
        var ecP = CustomNamedCurves.GetByName(CURVE);
        var ecSpec = new ECDomainParameters(ecP.Curve, ecP.G, ecP.N, ecP.H, ecP.GetSeed());
        var generator = (ECKeyPairGenerator)GeneratorUtilities.GetKeyPairGenerator(ALGORITHM);
        generator.Init(new ECKeyGenerationParameters(ecSpec, new SecureRandom()));
        return generator.GenerateKeyPair();
    }

    // Generating shared key
    public byte[] GetSharedSecretValue(string privKey, string pubKey)
    {
        var privateKey = GetPrivateKeyFrom(privKey);
        var publicKey = GetPublicKeyFrom(pubKey);
        var agreement = AgreementUtilities.GetBasicAgreement(ALGORITHM);
        agreement.Init(privateKey);
        var result = agreement.CalculateAgreement(publicKey);
        return result.ToByteArrayUnsigned();
    }

    // XOR of teo random string (sender and receiver)
    public IEnumerable<byte> XorOfRandom(string randomKeySender, string randomKeyReceiver)
    {
        var randomKeySenderBytes = GetByteFromBase64(randomKeySender).ToArray();
        var randomKeyReceiverBytes = GetByteFromBase64(randomKeyReceiver).ToArray();
        var sb = new byte[randomKeyReceiverBytes.Length];
        for (var i = 0; i < randomKeySenderBytes.Length; i++)
        {
            sb[i] = (byte)(randomKeySenderBytes[i] ^ randomKeyReceiverBytes[i % randomKeyReceiverBytes.Length]);
        }

        return sb;
    }

    // Generate 32 byte random Key 
    public string GenerateRandomKey()
    {
        var rngCryptoServiceProvider = new RNGCryptoServiceProvider();
        var randomBytes = new byte[32];
        rngCryptoServiceProvider.GetBytes(randomBytes);
        return GetBase64FromByte(randomBytes);
    }

    // Method for getting Aes key using HKDF
    public IEnumerable<byte> GenerateAesKey(string sharedKey, IEnumerable<byte> salt)
    {

        var hkdfBytesGenerator = new Kdf1BytesGenerator(new Sha256Digest());
        var hkdfParameters = new KdfParameters(GetByteFromBase64(sharedKey).ToArray(), salt.ToArray());
        hkdfBytesGenerator.Init(hkdfParameters);
        var aesKey = new byte[32];
        hkdfBytesGenerator.GenerateBytes(aesKey, 0, 32);
        return aesKey;
    }

    // Get base64 from byte array.
    public string GetBase64FromByte(IEnumerable<byte> value)
    {
        return Encoder.Base64.ToBase64String((byte[])value);
    }

    //Get byte array from string.
    public IEnumerable<byte> GetByteFromBase64(string value)
    {
        return Encoder.Base64.Decode(value);
    }

    // Converting Public key to string
    public string GetPublicKey(AsymmetricCipherKeyPair keyPair)
    {
        return Convert.ToBase64String(Org.BouncyCastle.X509.SubjectPublicKeyInfoFactory
            .CreateSubjectPublicKeyInfo(keyPair.Public).GetEncoded());
    }

    // Converting Private key to string
    public string GetPrivateKey(AsymmetricCipherKeyPair keyPair)
    {
        var keyInfo = PrivateKeyInfoFactory.CreatePrivateKeyInfo(keyPair.Private);
        var encoded = keyInfo.ToAsn1Object().GetDerEncoded();
        return GetBase64FromByte(encoded);
    }

    // Converting string to privateKey
    public AsymmetricKeyParameter GetPrivateKeyFrom(string privateKey)
    {
        return PrivateKeyFactory.CreateKey((byte[])GetByteFromBase64(privateKey));
    }

    // Converting string to publicKey
    public AsymmetricKeyParameter GetPublicKeyFrom(string publicKey)
    {
        return PublicKeyFactory.CreateKey((byte[])GetByteFromBase64(publicKey));
    }

    public  string CreateMD5CheckSum(string input)
    {
        // Use input string to calculate MD5 hash
        using (MD5 md5 = MD5.Create())
        {
            byte[] inputBytes = Encoding.ASCII.GetBytes(input);
            byte[] hashBytes = md5.ComputeHash(inputBytes);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hashBytes.Length; i++)
            {
                sb.Append(hashBytes[i].ToString("X2"));
            }
            return sb.ToString();
        }
    }

    // Generating shared key
    public byte[] GetSharedSecretValueForEncryption(string privKey, string pubKey)
    {
        var privateKey = GetPrivateKeyFrom(privKey);
        var ecP = CustomNamedCurves.GetByName(CURVE);
        var ecSpec = new ECDomainParameters(ecP.Curve, ecP.G, ecP.N, ecP.H, ecP.GetSeed());
        var publicKey = new ECPublicKeyParameters(ecSpec.Curve.DecodePoint((byte[])GetByteFromBase64(pubKey)), ecSpec);
        IBasicAgreement agreement = AgreementUtilities.GetBasicAgreement(ALGORITHM);
        agreement.Init(privateKey);
        BigInteger result = agreement.CalculateAgreement(publicKey);
        return result.ToByteArrayUnsigned();

        ////var privateKey = GetPrivateKeyFrom(privKey);
        ////var publicKey = GetPublicKeyFrom(pubKey);
        ////var agreement = AgreementUtilities.GetBasicAgreement(ALGORITHM);
        ////agreement.Init(privateKey);
        ////var result = agreement.CalculateAgreement(publicKey);
        ////return result.ToByteArrayUnsigned();
    }



    public string GetPublicKeyNew(AsymmetricCipherKeyPair keyPair)
    {
        SubjectPublicKeyInfo publicKeyInfo = SubjectPublicKeyInfoFactory.CreateSubjectPublicKeyInfo(keyPair.Public);
        byte[] serializedPublicBytes = publicKeyInfo.ToAsn1Object().GetDerEncoded();
        string serializedPublic = String.Concat(serializedPublicBytes);
        ECPublicKeyParameters ecKey = (ECPublicKeyParameters)keyPair.Public;
        return GetBase64FromByte(ecKey.Q.GetEncoded(false));
    }

    public string GetPrivateKeyNew(AsymmetricCipherKeyPair keyPair)
    {

        SubjectPublicKeyInfo publicKeyInfo = SubjectPublicKeyInfoFactory.CreateSubjectPublicKeyInfo(keyPair.Public);
        byte[] serializedPublicBytes = publicKeyInfo.ToAsn1Object().GetDerEncoded();
        string serializedPublic = String.Concat(serializedPublicBytes);
        ECPrivateKeyParameters ecKey = (ECPrivateKeyParameters)keyPair.Private;
        return GetBase64FromByte(ecKey.D.ToByteArray());

        // return ((ECPublicKeyParameters)keyPair.Public).Q.GetEncoded().ToString() ;

    }

    


}
