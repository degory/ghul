namespace Библиотека;

public class Чашка
{
    public Чашка(int größe)
    {
        Größe = größe;
    }

    public int Größe { get; }

    public string Описание() => $"{Größe}";
}
