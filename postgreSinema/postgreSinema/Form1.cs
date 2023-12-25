using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace postgreSinema
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=sinemadb; user ID=postgres; password=12345");
        private string filmAdi;

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            string sorgu = "select * from film";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void button2_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut1 = new NpgsqlCommand("insert into film (filmid,filmadi,sure,filmdili,puan,yassiniri) values (@p1,@p2,@p3,@p4,@p5,@p6)", baglanti);
            komut1.Parameters.AddWithValue("@p1", int.Parse(textBox1.Text));
            komut1.Parameters.AddWithValue("@p2", textBox6.Text);
            NpgsqlParameter npgsqlParameter = komut1.Parameters.AddWithValue("@p3", int.Parse(textBox5.Text));
            komut1.Parameters.AddWithValue("@p4", comboBox1.Text);
            komut1.Parameters.AddWithValue("@p5", double.Parse(textBox3.Text));
            komut1.Parameters.AddWithValue("@p6", int.Parse(textBox2.Text));
            komut1.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Film ekleme işlemi tamamlandı.");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut2 = new NpgsqlCommand("Delete from film where filmid=@p1", baglanti);
            komut2.Parameters.AddWithValue("@p1", int.Parse(textBox1.Text));
            komut2.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Ürün silme işlemi tamamlandı.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Stop);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            /*baglanti.Open();
            NpgsqlCommand komut3 = new NpgsqlCommand("update film set filmadi=@filmadi, sure=@sure, filmdili=@filmdili, puan=@puan, yassiniri=@yassiniri where urunid=@p6", baglanti);
            komut3.Parameters.AddWithValue("@filmid", Convert.ToInt32(textBox1.Text));
            komut3.Parameters.AddWithValue("@filmadi", textBox6.Text);
            komut3.Parameters.AddWithValue("@sure", Convert.ToInt32(textBox5.Text)); 
            komut3.Parameters.AddWithValue("@filmdili", comboBox1.Text);
            komut3.Parameters.AddWithValue("@puan", Convert.ToInt32(textBox3.Text)); 
            komut3.Parameters.AddWithValue("pyassiniri", Convert.ToInt32(textBox2.Text));
            MessageBox.Show("Ürün güncelleme işlemi tamamlandı.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            baglanti.Close() ;*/

            /*string sorgu = "UPDATE film SET filmadi=@filmadi, sure=@sure, filmdili=@filmdili, puan=@puan WHERE urunid=@urunid ";
            NpgsqlCommand komut = new NpgsqlCommand(sorgu);
            komut = new NpgsqlCommand(sorgu, baglanti);*/

            try
            {
                baglanti.Open();

                NpgsqlCommand komut3 = new NpgsqlCommand("update film set filmadi=@filmadi, sure=@sure, filmdili=@filmdili, puan=@puan, yassiniri=@yassiniri where filmid=@filmid", baglanti);
                komut3.Parameters.AddWithValue("@filmid", Convert.ToInt32(textBox1.Text));
                komut3.Parameters.AddWithValue("@filmadi", textBox6.Text);
                komut3.Parameters.AddWithValue("@sure", Convert.ToInt32(textBox5.Text));
                komut3.Parameters.AddWithValue("@filmdili", comboBox1.Text);
                komut3.Parameters.AddWithValue("@puan", Convert.ToInt32(textBox3.Text));
                komut3.Parameters.AddWithValue("@yassiniri", Convert.ToInt32(textBox2.Text)); // Parametre adı "yassiniri" olarak değiştirildi.

                komut3.ExecuteNonQuery(); // Komutu çalıştır

                MessageBox.Show("Ürün güncelleme işlemi tamamlandı.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message, "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                baglanti.Close(); // Bağlantıyı kapat, hata olsa da olmasa da
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            string filmAdi = button5.Text.Trim();

            if (!string.IsNullOrEmpty(filmAdi))
            {
                AramaYapVeGridGuncelle(filmAdi);
            }
            else
            {
                MessageBox.Show("Lütfen bir film adı girin.", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void AramaYapVeGridGuncelle(string filmAdi)
        {
            try
            {
                baglanti.Open();

                NpgsqlCommand komutArama = new NpgsqlCommand("SELECT * FROM film WHERE filmadi ILIKE @filmadi", baglanti);
                komutArama.Parameters.AddWithValue("@filmadi", "%" + filmAdi + "%");

                NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(komutArama);
                DataTable dataTable = new DataTable();
                adapter.Fill(dataTable);

                if (dataTable.Rows.Count > 0)
                {
                    dataGridView1.DataSource = dataTable;
                }
                else
                {
                    MessageBox.Show("Belirtilen film adına ait kayıt bulunamadı.", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message, "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                baglanti.Close();
            }
        }

        private void button6_Click(object sender, EventArgs e)
        {
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select *from EnYuksekPuandakiFilmleriGetir3()", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            dataGridView1.DataSource= dt;

        }

        private void button7_Click(object sender, EventArgs e)
        {
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select *from OyuncununFilmleriniListele('" + int.Parse(textBox4.Text)+ "')", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            dataGridView1.DataSource = dt;
        }

        private void button8_Click(object sender, EventArgs e)
        {
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select *from cocuk_bilet_fiyati_hesapla('" + int.Parse(textBox7.Text) + "')", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            dataGridView1.DataSource = dt;
        }

        private void button9_Click(object sender, EventArgs e)
        {
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select *from indirimli_fiyat_hesapla('" + int.Parse(textBox8.Text) + "')", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            dataGridView1.DataSource = dt;
        }
    }
}

